class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :target, polymorphic: true
  serialize :parameters, JSON
  enum kind: [
    :submission_create,
    :contest_create,
    :contest_update,
    :tag_create,
  ]

  scope :recent, lambda { |count|
    order(:id).reverse_order.limit(count)
  }
end
