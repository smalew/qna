
class LinksSerializer < ActiveModel::Serializer
  attributes :id, :name, :url

  include SerializedTimestampable
end
