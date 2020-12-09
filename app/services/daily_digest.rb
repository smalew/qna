# frozen_string_literal: true

class DailyDigest
  def send_digest
    questions = Question.where(created_at: Date.today.all_day).pluck(:title, :body).to_h

    User.find_each(batch_size: 500) do |user|
      DailyDigestMailer.digest(user, questions: questions.to_a).deliver_later
    end
  end
end
