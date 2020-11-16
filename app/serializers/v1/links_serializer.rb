module V1
  class LinksSerializer < ActiveModel::Serializer
    attributes :id, :name, :url

    include V1::SerializedTimestampable
  end
end
