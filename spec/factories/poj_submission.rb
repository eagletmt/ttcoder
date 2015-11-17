FactoryGirl.define do
  sequence :poj_user do |n|
    "farmer_john#{n}"
  end

  factory :poj_submission do
    user { generate :poj_user }
    problem_id
    language 'G++'
    length 100
    submitted_at { Time.zone.now }

    factory :poj_submission_ac do
      result 'Accepted'
      time 0
      memory 0
    end

    factory :poj_submission_wa do
      result 'Wrong Answer'
    end
  end
end
