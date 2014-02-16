class ContestsSiteProblem < ActiveRecord::Base
  belongs_to :contest
  belongs_to :site_problem

  acts_as_list scope: :contest

  validates :site_problem_id, uniqueness: { scope: :contest_id }
end
