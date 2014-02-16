module FluentLoggerHelper
  def logger
    Fluent::Logger.class_variable_get(:@@default_logger)
  end

  def last_log(tag)
    logger.queue.select { |h| h.tag == tag }.last
  end
end

RSpec.configure do |config|
  config.include(FluentLoggerHelper)

  config.before(:suite) do
    Fluent::Logger::TestLogger.open
  end

  config.after(:each) do
    logger.queue.clear
  end
end
