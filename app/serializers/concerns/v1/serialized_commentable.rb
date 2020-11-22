# frozen_string_literal: true

module V1
  module SerializedCommentable
    extend ActiveSupport::Concern

    included do
      has_many :comments, serializer: V1::CommentsSerializer
    end
  end
end
