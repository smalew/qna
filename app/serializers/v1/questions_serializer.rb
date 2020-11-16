module V1
  class QuestionsSerializer < ActiveModel::Serializer
    attributes :id, :title, :body, :short_title

    include V1::SerializedTimestampable

    has_many :answers
    belongs_to :user

    def short_title
      object.title.truncate(7)
    end
  end
end
