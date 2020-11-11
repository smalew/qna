module Api
  module V1
    class AnswersController < BaseController
      include Crudable

      private

        def question
          @question ||= Question.find_by(id: params[:question_id])
        end

        def records
          @records ||= question.answers
        end

        def record
          @record ||= Answer.find_by(id: params[:id]) || records.build(record_params)
        end

        def records_serializer
          AnswersSerializer
        end

        def record_serializer
          AnswerSerializer
        end

        def record_params
          params.require(:answer).permit(:body, links_attributes: [:name, :url])
        end
    end
  end
end
