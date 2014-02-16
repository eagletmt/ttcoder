module Submission
  extend ActiveSupport::Concern

  included do
    scope :accepts, lambda { where(status_field => 'Accepted') }

    scope :between, lambda { |from, to|
      where("#{submitted_at_field} >= ?", from.in_time_zone)
      .where("#{submitted_at_field} < ?", to.in_time_zone)
    }

    scope :order_by_submission, lambda {
      order("#{submitted_at_field} DESC")
    }

    scope :recent, lambda {
      where("#{submitted_at_field} > ?", 1.month.ago).order_by_submission
    }

    scope :user, lambda { |user|
      column_name = "lower(#{quoted_user_column_name})"
      if user.is_a?(Array)
        where("#{column_name} IN (?)", user)
      else
        where("#{column_name} = ?", user)
      end
    }

    scope :group_by_user, lambda {
      group("lower(#{quoted_user_column_name})")
    }

    validates :problem_id, presence: true, format: /\A\d+\z/

    after_save :update_standing_cache!
  end

  def abbrev_status
    self.class.status_abbreviations[attributes[self.class.status_field.to_s]]
  end

  def update_standing_cache!
    StandingCache.update!(
      user: self[self.class.user_field].downcase,
      problem_type: self.class.site,
      problem_id: problem_id.to_s,
      status: self[self.class.status_field],
      submitted_at: self[self.class.submitted_at_field],
    )
  end

  module ClassMethods
    attr_accessor :site
    attr_accessor :user_field, :status_field, :submitted_at_field
    attr_accessor :status_abbreviations

    def quoted_user_column_name
      @quoted_user_column_name ||= connection.quote_column_name(user_field)
    end

    def make_usermap(users)
      users.index_by { |user| user.user_in(site).downcase }
    end

    def solved_users(problem_id)
      site2user = make_usermap(User.all)
      StandingCache.where(
        user: site2user.keys,
        problem_id: problem_id,
        problem_type: site,
        status: 'Accepted',
      ).pluck(:user).map do |user|
        site2user[user]
      end
    end

    def standing(users, problem_ids)
      site2user = make_usermap(users)

      h = Hash.new { |h1, k1| h1[k1] = {} }
      StandingCache.where(
        user: site2user.keys,
        problem_id: problem_ids,
        problem_type: site
      ).each do |c|
        h[site2user[c.user].name][c.problem_id] = {
          status: status_abbreviations[c.status],
          submitted_at: c.submitted_at,
        }
      end
      site2user.each_key do |aoj_user|
        problem_ids.each do |problem_id|
          h[site2user[aoj_user].name][problem_id] ||= nil
        end
      end
      h
    end
  end
end
