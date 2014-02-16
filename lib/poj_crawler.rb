require 'faraday'
require 'nokogiri'

class PojCrawler
  def run(opts = {})
    n = opts.fetch(:count, 10_000)
    size = opts.fetch(:size, 500)

    top = 100_000_000
    if opts[:continue]
      top = PojSubmission.order(:id).first.id
    end
    if opts[:top]
      top = opts[:top]
    end

    n.times do |i|
      params = { size: size, top: top }
      from = Time.now
      top = crawl(params)
      to = Time.now
      Fluent::Logger.post('crawl_poj', params: params, duration: (to - from))
      break unless top
    end
  end

  def crawl(params)
    @conn ||= Faraday.new(url: 'http://poj.org/') do |faraday|
      faraday.use Faraday::Response::RaiseError
      faraday.adapter Faraday.default_adapter
    end

    res = @conn.get('status', params)
    doc = Nokogiri::HTML.parse(res.body)
    subs = {}
    doc.css('table.a tr[align=center]').each do |tr|
      tds = tr.xpath('td').map(&:inner_text)
      sub = PojSubmission.new
      sub.id = tds[0].to_i
      sub.user = tds[1]
      sub.problem_id = tds[2].to_i
      sub.result = tds[3]
      if sub.result == 'Accepted'
        sub.memory = tds[4].to_i
        sub.time = tds[5].to_i
      end
      sub.language = tds[6]
      sub.length = tds[7]
      sub.submitted_at = Time.parse(tds[8] + ' +0800')  # XXX
      subs[sub.id] = sub
    end

    PojSubmission.where(id: subs.keys).pluck(:id).each do |existing_id|
      subs.delete(existing_id)
    end
    return nil if subs.empty?

    Fluent::Logger.post('poj_import', submissions: subs.values.map(&:attributes))
    ActiveRecord::Base.transaction do
      subs.each_value do |sub|
        if sub.valid?
          sub.save!
        else
          sub.errors.each do |attr, msg|
            unless sub.ignorable_error?(attr, msg)
              Fluent::Logger.post('poj_import_error', attribute: attr, value: sub.public_send(attr), message: msg)
            end
          end
        end
      end
    end

    subs.keys.min
  rescue Faraday::Error::ClientError => e
    Fluent::Logger.post('poj_http_error', {
      message: e.message,
      backtrace: Rails.backtrace_cleaner.clean(e.backtrace),
    })
  end
end
