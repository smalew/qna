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
class Rate < ApplicationRecord
  include HasUser
  belongs_to :ratable, polymorphic: true

  enum status: { negative: -1, positive: 1 }

  scope :positives, -> { where(status: :positive) }
  scope :negatives, -> { where(status: :negative) }
end
