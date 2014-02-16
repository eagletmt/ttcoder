case Rails.env
when 'production'
  Fluent::Logger::FluentLogger.open('ttcoder', host: 'localhost', port: 24224)
when 'development', 'test'
  Fluent::Logger::NullLogger.open
end
