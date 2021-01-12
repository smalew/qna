# frozen_string_literal: true

class DailyDigestMailer < ApplicationMailer
  def digest(user, questions: [])
    @user = user
    @questions = questions

    mail to: @user.email
  end
end
