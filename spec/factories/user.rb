FactoryGirl.define do
  sequence :user_name do |n|
    "User#{n}"
  end

  sequence :poj_user_name do |n|
    "Poj_User#{n}"
  end

  sequence :aoj_user_name do |n|
    "Aoj_User#{n}"
  end

  factory :user do
    name { generate :user_name }
    poj_user { generate :poj_user_name }
    aoj_user { generate :aoj_user_name }
  end
end
