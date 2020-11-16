module V1
  class AnswerSerializer < ActiveModel::Serializer
    attributes :id, :body, :best_answer, :user_id

    include V1::SerializedFilable
    include V1::SerializedTimestampable
    include V1::SerializedLinkable
    include V1::SerializedCommentable
  end
end
