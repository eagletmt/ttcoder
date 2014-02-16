FactoryGirl.define do
  sequence :contest_name do |n|
    "Contest ##{n}"
  end

  factory :contest do
    name { generate :contest_name }
  end
end
