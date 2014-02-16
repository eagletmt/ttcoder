$redis = Redis.new
if Rails.env.production?
  # Ensure redis is up
  $redis.ping
end
