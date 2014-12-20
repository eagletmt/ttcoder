# Be sure to restart your server when you modify this file.

Rails.application.config.session_store(
  ActionDispatch::Session::CacheStore,
  namespace: 'ttcoder:sessions',
  serializer: JSON,
  expire_after: 1.month,
)
