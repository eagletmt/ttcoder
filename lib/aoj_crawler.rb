require 'faraday'
require 'nokogiri'

class AojCrawler
  def run(opts = {})
    params = opts.slice(:limit, :start)
    params[:limit] ||= 100
    params[:start] ||= 0
    n = opts.delete(:count) || 10_000

    n.times do
      from = Time.now
      r = crawl(params)
      to = Time.now
      Fluent::Logger.post('crawl_aoj', params: params, duration: (to - from))

      break unless r
      params[:start] += params[:limit]
    end
  end

  def crawl(params)
    @conn ||= Faraday.new(url: 'http://judge.u-aizu.ac.jp/onlinejudge/webservice/') do |faraday|
      faraday.use Faraday::Response::RaiseError
      faraday.adapter Faraday.default_adapter
    end

    res = @conn.get('status_log', params)
    doc = Nokogiri::XML.parse(res.body)
    subs = {}
    doc.xpath('/status_list/status').each do |status|
      h = {}
      status.elements.each do |e|
        h[e.name] = e.inner_text.strip
      end
      h.delete('submission_date_str')
      h['submission_date'] = Time.at(h['submission_date'].to_i / 1000)
      h['run_id'] = h['run_id'].to_i
      subs[h['run_id']] = AojSubmission.new(h)
    end

    AojSubmission.where(run_id: subs.keys).pluck(:run_id).each do |existing_id|
      subs.delete(existing_id)
    end
    return false if subs.empty?

    Fluent::Logger.post('aoj_import', submissions: subs.values.map(&:attributes))
    ActiveRecord::Base.transaction do
      subs.each_value do |sub|
        if sub.valid?
          sub.save!
        else
          sub.errors.each do |attr, msg|
            Fluent::Logger.post('aoj_import_error', attribute: attr, value: sub.public_send(attr), message: msg)
          end
        end
      end
    end
    true
  rescue Faraday::Error::ClientError => e
    Fluent::Logger.post('aoj_http_error', {
      message: e.message,
      backtrace: Rails.backtrace_cleaner.clean(e.backtrace),
    })
    true
  end
end
