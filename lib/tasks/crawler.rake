namespace :crawler do
  desc 'Run crawlers periodically'
  task :work => [:environment] do
    if Rails.env.production?
      # Re-configure
      Raven.configure do |config|
        config.dsn = "fluentd://#{ENV['SENTRY_PUBLIC_KEY_CRAWLER']}:#{ENV['SENTRY_SECRET_KEY_CRAWLER']}@localhost:24224/3"
      end
    end

    require 'aoj_crawler'
    require 'poj_crawler'

    INTERVAL = 5.minutes

    def start_crawler(klass)
      Thread.start do
        crawler = klass.new
        loop do
          begin
            crawler.run
          rescue Exception => e
            Raven.capture_exception(e)
          end
          sleep INTERVAL
        end
      end
    end

    poj_thread = start_crawler(PojCrawler)
    sleep 1.minute
    aoj_thread = start_crawler(AojCrawler)

    poj_thread.join
    aoj_thread.join
  end
end
