module SerializedCommentable
  extend ActiveSupport::Concern

  included do
    has_many :comments, serializer: CommentsSerializer
  end
end
