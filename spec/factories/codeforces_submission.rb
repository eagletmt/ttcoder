FactoryGirl.define do
  sequence :codeforces_handle do |n|
    "Codeforces_OtherUser#{n}"
  end
  sequence :codeforces_problem_id do |n|
    "#{n}A"
  end

  factory :codeforces_submission do
    problem_id { generate :codeforces_problem_id }
    handle { generate :codeforces_handle }
    programming_language 'GNU C++11'
    time_consumed_millis 0
    memory_consumed_bytes 0
    submission_time { Time.zone.now }

    factory :codeforces_submission_ac do
      verdict 'OK'
    end

    factory :codeforces_submission_wa do
      verdict 'WRONG_ANSWER'
    end
  end
end
