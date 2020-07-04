class Question < ApplicationRecord
  belongs_to :user
  belongs_to :best_answer, class_name: 'Answer', foreign_key: :best_answer_id, required: false

  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true
end
