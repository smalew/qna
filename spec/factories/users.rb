# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  admin                  :boolean
#
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }

    password { '123456789' }
    password_confirmation { '123456789' }

    trait :empty_password do
      password { '' }
      password_confirmation { '' }
    end
  end
end
