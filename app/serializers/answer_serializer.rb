class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :best_answer, :user_id

  include SerializedFilable
  include SerializedTimestampable
  include SerializedLinkable
  include SerializedCommentable
end
