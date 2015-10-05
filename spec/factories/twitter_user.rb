FactoryGirl.define do
  sequence(:twitter_uid, &:to_s)

  sequence :twitter_user_name do |n|
    "Twitter_User#{n}"
  end

  factory :twitter_user do
    name { generate :twitter_user_name }
    uid { generate :twitter_uid }
    user
    token 'oauth-token'
    secret 'oauth-secret'
  end
end
