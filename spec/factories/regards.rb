# frozen_string_literal: true

# == Schema Information
#
# Table name: regards
#
#  id          :bigint           not null, primary key
#  question_id :bigint
#  answer_id   :bigint
#  title       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :regard do
    question
    answer

    sequence(:title) { |n| "Regard title #{n}" }
    image { fixture_file_upload(Rails.root.join('spec', 'images', 'regard.jpg')) }
  end
end
