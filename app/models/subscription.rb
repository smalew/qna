# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  user_id     :bigint
#
class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :question
end
