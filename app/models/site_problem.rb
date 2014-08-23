class SiteProblem < ActiveRecord::Base
  SITES = %w[poj aoj]
  validates :site, presence: true, inclusion: { in: SITES }
  validates :problem_id, presence: true, uniqueness: { scope: :site }, format: /\A\d+\z/

  has_many :contests_site_problems
  has_many :contests, through: :contests_site_problems
  has_many :taggings
  has_many :tags, through: :taggings

  def description
    self.class.description(site, problem_id)
  end

  module ClassMethods
    def description(site, problem_id)
      "#{site.upcase} #{problem_id}"
    end

    def solved_users(site, problem_id)
      submission_class_for(site).solved_users(problem_id)
    end

    def submission_class_for(site)
      "#{site.capitalize}Submission".constantize
    end

    def standing_for(site, users, problems)
      submission_class_for(site).standing(users, problems.map(&:problem_id))
    end
  end
  extend ClassMethods
end
