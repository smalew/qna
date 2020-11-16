module V1
  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :admin

    include V1::SerializedTimestampable
  end
end
