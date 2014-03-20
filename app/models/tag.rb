class Tag < ActiveRecord::Base
  validates :name, uniqueness: true, format: /\A[a-z0-9-]+\z/
  validates :owner_id, presence: true

  belongs_to :owner, class_name: 'User'

  def to_param
    name
  end
end
