class SiteProblem < ActiveRecord::Base
  SITES = %w[poj aoj codeforces]
  validates :site, presence: true, inclusion: { in: SITES }
  validates :problem_id, presence: true, uniqueness: { scope: :site }
  validates :problem_id, format: /\A\d+\z/, if: :numeric_problem_id_site?
  validates :problem_id, format: /\A\d+[A-Z]\d?\z/, if: :contest_index_problem_id_site?

  has_many :contests_site_problems
  has_many :contests, through: :contests_site_problems
  has_many :taggings
  has_many :tags, through: :taggings

  SITE_DESCRIPTIONS = {
    'aoj' => :upper_description,
    'poj' => :upper_description,
    'codeforces' => :capitalized_description,
  }

  def description
    self.class.description(site, problem_id)
  end

  module ClassMethods
    def description(site, problem_id)
      self.send(SITE_DESCRIPTIONS[site], site, problem_id)
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

    private
    def upper_description(site, problem_id)
      "#{site.upcase} #{problem_id}"
    end

    def capitalized_description(site, problem_id)
      "#{site.capitalize} #{problem_id}"
    end
  end
  extend ClassMethods

  private
  def numeric_problem_id_site?
    %w[poj aoj].include?(site)
  end

  def contest_index_problem_id_site?
    %w[codeforces].include?(site)
  end
end
