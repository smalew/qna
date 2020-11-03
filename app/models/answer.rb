class Answer < ApplicationRecord
  include HasUser
  include HasQuestion

  include Linkable
  include Filable
  include Commentable

  has_one :regard
  has_many :rates, as: :ratable, dependent: :destroy

  scope :casual, -> { where(best_answer: false) }
  scope :best, -> { where(best_answer: true) }
  scope :ordered_by_best, -> { order(best_answer: :desc) }

  validates :body, presence: :true

  def choose_as_best
    Answer.transaction do
      question.best_answer&.update!(best_answer: false, regard: nil)
      update!(best_answer: true, regard: question.regard)
    end
  end
end
