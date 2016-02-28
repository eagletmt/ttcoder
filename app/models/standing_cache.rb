class StandingCache < ActiveRecord::Base
  validates :user, format: /\A[a-z0-9_\.\-]+\z/

  def update?(attrs)
    if status == 'Accepted'
      attrs[:status] == 'Accepted' && submitted_at < attrs[:submitted_at]
    else
      attrs[:status] == 'Accepted' || submitted_at < attrs[:submitted_at]
    end
  end

  module ClassMethods
    def update!(attrs)
      c = find_by(attrs.slice(:user, :problem_type, :problem_id))
      if c.nil?
        create!(attrs)
      elsif c.update?(attrs)
        c.update!(attrs)
      else
        false
      end
    end
  end
  extend ClassMethods
end
