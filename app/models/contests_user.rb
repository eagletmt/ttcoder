class ContestsUser < ActiveRecord::Base
  belongs_to :contest
  belongs_to :user

  validates :user_id, uniqueness: { scope: :contest_id }
end
