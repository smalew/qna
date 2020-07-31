class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :ratable, polymorphic: true

  scope :positives, -> { where(positive: true) }
  scope :negatives, -> { where(negative: true) }
end
