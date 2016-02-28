FactoryGirl.define do
  sequence(:problem_id, &:to_s)

  factory :problem, class: SiteProblem do
    problem_id { generate(:problem_id) }

    factory :poj_problem do
      site 'poj'
    end

    factory :aoj_problem do
      site 'aoj'
    end

    factory :codeforces_problem do
      site 'codeforces'
      problem_id { generate :codeforces_problem_id }
    end
  end
end
