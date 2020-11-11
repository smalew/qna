class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id

  include SerializedFilable
  include SerializedTimestampable
  include SerializedLinkable
  include SerializedCommentable
end
