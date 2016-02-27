require 'faraday'
require 'json'

class CodeforcesCrawler
  def run(opts = {})
    params = {}
    params[:count] = opts[:count] || 1000
    from = Time.now
    crawl(params)
    to = Time.now
    Fluent::Logger.post('crawl_codeforces', params: params, duration: (to - from))
  end

  def crawl(params)
    @conn ||= Faraday.new(url: 'http://codeforces.com/api/') do |faraday|
      faraday.use Faraday::Response::RaiseError
      faraday.adapter Faraday.default_adapter
    end

    res = @conn.get('problemset.recentStatus', params)
    subs = extract_submissions(JSON.parse(res.body))
    remove_existing_submissions(subs)
    return false if subs.empty?
    Fluent::Logger.post('codeforces_import', submissions: subs.values.map(&:attributes))
    ActiveRecord::Base.transaction do
      subs.each_value do |sub|
        insert_submission(sub)
      end
    end
    true
  end

  def extract_submissions(res)
    subs = {}
    res['result'].each do |result|
      h = {}
      result.each { |key,value| h[key.underscore] = value }
      h.slice!(*%w{id programming_language verdict time_consumed_millis memory_consumed_bytes})
      h['submission_time'] = Time.at(result['creationTimeSeconds'])
      h['handle'] = result['author']['members'].first['handle']
      h['problem_id'] = result['problem']['contestId'].to_s + result['problem']['index']
      subs[h['id']] = CodeforcesSubmission.new(h)
    end
    subs
  end

  def remove_existing_submissions(subs)
    CodeforcesSubmission.where(id: subs.keys).pluck(:id).each do |existing_id|
      subs.delete(existing_id)
    end
  end

  def insert_submission(sub)
    if sub.valid?
      sub.save!
    else
      sub.errors.each do |attr, msg|
        Fluent::Logger.post('codeforces_import_error', attribute: attr, value: sub.public_send(attr), message: msg)
      end
    end
  end
end
