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
class Regard < ApplicationRecord
  include HasQuestion
  include Imagable

  belongs_to :answer, required: false

  has_one_attached :image

  validates :title, presence: true
end
