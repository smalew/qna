class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  scope :casual, -> { where(best_answer: false) }
  scope :best, -> { where(best_answer: true) }

  validates :body, presence: :true
end
