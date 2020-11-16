module V1
  class AnswersSerializer < ActiveModel::Serializer
    attributes :id, :body, :best_answer, :user_id, :short_body

    def short_body
      object.body.truncate(10)
    end

    include V1::SerializedTimestampable
  end
end
