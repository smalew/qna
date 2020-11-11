module SerializedLinkable
  extend ActiveSupport::Concern

  included do
    has_many :comments, serializer: CommentsSerializer
    has_many :links, serializer: LinksSerializer
  end
end
