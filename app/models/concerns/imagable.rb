module Imagable
  extend ActiveSupport::Concern

  included do
    has_one_attached :image

    validates :image, presence: true
  end
end
