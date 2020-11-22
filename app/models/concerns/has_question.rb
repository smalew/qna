# frozen_string_literal: true

module HasQuestion
  extend ActiveSupport::Concern

  included do
    belongs_to :question
  end
end
