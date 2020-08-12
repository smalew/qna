class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'answers'
  end
end
