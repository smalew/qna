
class CommentsSerializer < ActiveModel::Serializer
  attributes :id, :body

  include SerializedTimestampable
end
