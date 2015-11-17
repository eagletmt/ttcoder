FactoryGirl.define do
  sequence :aoj_run_id
  sequence :aoj_user_id do |n|
    "Aoj_OtherUser#{n}"
  end
  sequence :aoj_problem_id do |n|
    sprintf '%04d', n
  end

  factory :aoj_submission do
    run_id { generate :aoj_run_id }
    user_id { generate :aoj_user_id }
    problem_id { generate :aoj_problem_id }
    language 'C++'
    cputime 0
    memory 0
    code_size 100
    submission_date { Time.zone.now }

    factory :aoj_submission_ac do
      status 'Accepted'
    end

    factory :aoj_submission_wa do
      status 'Wrong Answer'
    end
  end
end
