# frozen_string_literal: true

# == Schema Information
#
# Table name: rates
#
#  id           :bigint           not null, primary key
#  user_id      :bigint
#  ratable_type :string
#  ratable_id   :bigint
#  status       :integer          default("positive"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
FactoryBot.define do
  factory :rate do
    user
    association :ratable, factory: :question

    status { -1 }
  end
end
