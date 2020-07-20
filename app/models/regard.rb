class Regard < ApplicationRecord
  belongs_to :question
  belongs_to :answer, required: false

  has_one_attached :image

  validates :title, :image, presence: true
end
