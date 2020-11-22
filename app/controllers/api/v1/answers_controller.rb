# frozen_string_literal: true

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

      def record_params
        params.require(:answer).permit(:body, links_attributes: %i[name url])
      end
    end
  end
end
