FactoryGirl.define do
  sequence :problem_id do |n|
    n.to_s
  end

  factory :problem, class: SiteProblem do
    problem_id { generate(:problem_id) }

    factory :poj_problem do
      site 'poj'
    end

    factory :aoj_problem do
      site 'aoj'
    end
  end
end
