class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many_attached :files

  scope :casual, -> { where(best_answer: false) }
  scope :best, -> { where(best_answer: true) }
  scope :ordered_by_best, -> { order(best_answer: :desc) }

  validates :body, presence: :true

  def choose_as_best
    Answer.transaction do
      question.best_answer&.update!(best_answer: false)
      update!(best_answer: true)
    end
  end
end
