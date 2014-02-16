OmniAuth.config.test_mode = true

OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
  provider: 'twitter',
  uid: '9123',
  info: {
    nickname: 'Twitter_User9123',
  },
  credentials: {
    token: 'token',
    secret: 'secret',
  },
)
