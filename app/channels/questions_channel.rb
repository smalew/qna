# frozen_string_literal: true

class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'questions'
  end
end
