namespace :crawler do
  desc 'Run crawlers periodically'
  task :work => [:environment] do
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
            Fluent::Logger.post("#{klass.name.underscore}_error", {
              crawler_class: klass.name,
              class: e.class.name,
              message: e.message,
              backtrace: e.backtrace,
            })
            AlertMailer.crawler_error(klass, e)
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
