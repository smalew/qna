# frozen_string_literal: true

class QuestionsUpdateMailer < ApplicationMailer
  def notify(subscriber, question, answer)
    @subscriber = subscriber
    @question = question
    @answer = answer

    mail to: @subscriber.email
  end
end
