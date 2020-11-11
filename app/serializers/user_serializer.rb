
class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :admin

  include SerializedTimestampable
end
