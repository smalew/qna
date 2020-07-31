module Answerable
  extend ActiveSupport::Concern

  included do
    has_many :answers, dependent: :destroy
  end
end
