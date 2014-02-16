class Contest < ActiveRecord::Base
  include ParamAttribute
  validate_as_param :name

  belongs_to :owner, class_name: 'User'
  has_many :contests_users, lambda { uniq }
  has_many :users, -> { order('lower(name)') }, through: :contests_users
  has_many :contests_site_problems, lambda { order(:position) }
  has_many :site_problems, through: :contests_site_problems

  default_scope { order('contests.id DESC') }

  def to_param
    name
  end
end
