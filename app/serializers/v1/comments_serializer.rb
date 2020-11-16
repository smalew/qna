module V1
  class CommentsSerializer < ActiveModel::Serializer
    attributes :id, :body

    include V1::SerializedTimestampable
  end
end
