class Regard < ApplicationRecord
  include HasQuestion
  include Imagable

  belongs_to :answer, required: false

  has_one_attached :image

  validates :title, presence: true
end
