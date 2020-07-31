module Questionable
  extend ActiveSupport::Concern

  included do
    has_many :questions, dependent: :destroy
  end
end
