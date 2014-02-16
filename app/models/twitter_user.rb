class TwitterUser < ActiveRecord::Base
  self.primary_key = :uid
  belongs_to :user
end
