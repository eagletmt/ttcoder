case Rails.env
when 'production'
  Fluent::Logger.open(Fluent::Logger::FluentLogger, 'ttcoder', host: 'localhost', port: 24224)
when 'development', 'test'
  Fluent::Logger.open(Fluent::Logger::NullLogger)
end
