FactoryGirl.define do
  sequence :tag_name do |n|
    "tag-#{n}"
  end

  factory :tag do
    name { generate(:tag_name) }
    owner { create(:user) }
  end
end
