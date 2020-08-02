class Rate < ApplicationRecord
  belongs_to :user
  belongs_to :ratable, polymorphic: true

  enum status: { negative: -1, positive: 1 }

  scope :positives, -> { where(status: :positive) }
  scope :negatives, -> { where(status: :negative) }
end
