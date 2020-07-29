class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_one :regard

  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

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
