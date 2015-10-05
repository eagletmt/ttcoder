module FluentLoggerHelper
  def logger
    Fluent::Logger.default
  end

  def last_log(tag)
    logger.queue.reverse.find { |h| h.tag == tag }
  end
end

RSpec.configure do |config|
  config.include(FluentLoggerHelper)

  config.before(:suite) do
    Fluent::Logger.open(Fluent::Logger::TestLogger)
  end

  config.after(:each) do
    logger.queue.clear
  end
end
