class QuestionsSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :short_title

  include SerializedTimestampable

  has_many :answers
  belongs_to :user

  def short_title
    object.title.truncate(7)
  end
end
