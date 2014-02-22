module LoginHelper
  def login(provider, user)
    OmniAuth.config.mock_auth[:twitter][:uid] = user.twitter_user.uid
    visit auth_path(provider)
  end
end

RSpec.configure do |config|
  config.include(LoginHelper, type: :feature)
end
