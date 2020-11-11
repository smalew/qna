module Api
  module V1
    class QuestionsController < BaseController
      include Crudable

      private

        def records
          @questions ||= Question.all
        end

        def record
          @question ||= params[:id].present? ? Question.find(params[:id]) : Question.new(record_params)
        end

        def records_serializer
          QuestionsSerializer
        end

        def record_serializer
          QuestionSerializer
        end

        def record_params
          params.require(:question).permit(:title, :body, links_attributes: [:name, :url])
        end
    end
  end
end
