module V1
  module SerializedLinkable
    extend ActiveSupport::Concern

    included do
      has_many :comments, serializer: V1::CommentsSerializer
      has_many :links, serializer: V1::LinksSerializer
    end
  end
end
