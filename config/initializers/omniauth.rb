Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter,
    Rails.application.secrets.omniauth['twitter']['consumer_key'],
    Rails.application.secrets.omniauth['twitter']['consumer_secret']
end
