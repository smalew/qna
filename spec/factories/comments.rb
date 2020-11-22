# frozen_string_literal: true

# == Schema Information
#
# Table name: comments
#
#  id               :bigint           not null, primary key
#  user_id          :bigint
#  commentable_type :string
#  commentable_id   :bigint
#  body             :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
FactoryBot.define do
  factory :comment do
    user
    association :commentable, factory: :question

    body { 'Some comment body' }

    trait :empty_body do
      body { '' }
    end
  end
end
