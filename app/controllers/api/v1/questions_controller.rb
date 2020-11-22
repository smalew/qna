# frozen_string_literal: true

module Api
  module V1
    class QuestionsController < BaseController
      include Crudable

      private

      def records
        @records ||= Question.all
      end

      def record
        @record ||= params[:id].present? ? Question.find(params[:id]) : Question.new(record_params)
      end

      def record_params
        params.require(:question).permit(:title, :body, links_attributes: %i[name url])
      end
    end
  end
end
