class Tag < ActiveRecord::Base
  validates :name, uniqueness: true, format: /\A[a-z0-9-]+\z/
  validates :owner_id, presence: true

  belongs_to :owner, class_name: 'User'

  has_many :taggings, dependent: :destroy
  has_many :site_problems, through: :taggings

  after_create :create_create_activity

  def to_param
    name
  end

  private

  def create_create_activity
    Activity.create(user: owner, target: self, kind: :tag_create)
  end
end
