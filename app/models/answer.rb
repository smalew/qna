# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  body        :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint
#  best_answer :boolean          default(FALSE)
#
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

  validates :body, presence: true

  after_create :broadcast_subscribers

  def choose_as_best
    Answer.transaction do
      question.best_answer&.update!(best_answer: false, regard: nil)
      update!(best_answer: true, regard: question.regard)
    end
  end

  private

  def broadcast_subscribers
    question.subscribers.each do |subscriber|
      QuestionsUpdateMailer.notify(subscriber, question, self).deliver_later
    end
  end
end
