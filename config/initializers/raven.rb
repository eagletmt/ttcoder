Raven.configure do |config|
  config.dsn = "fluentd://#{ENV['SENTRY_PUBLIC_KEY']}:#{ENV['SENTRY_SECRET_KEY']}@localhost:24224/2"
  config.environments = %w[production]
  begin
    config.release = Rails.root.join('REVISION').read
  rescue Errno::ENOENT
  end
end
