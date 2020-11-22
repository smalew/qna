# frozen_string_literal: true

module V1
  class QuestionSerializer < ActiveModel::Serializer
    attributes :id, :title, :body, :user_id

    include V1::SerializedFilable
    include V1::SerializedTimestampable
    include V1::SerializedLinkable
    include V1::SerializedCommentable
  end
end
