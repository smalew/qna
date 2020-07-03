class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer.user = current_user
    answer.save
  end

  def update
    answer.update(answer_params)
    @question = answer.question
  end

  def destroy
    if current_user.author_of?(answer) && answer.destroy
      redirect_to question_path(answer.question), notice: I18n.t('answer.successful_destroy')
    else
      redirect_to question_path(answer.question), alert: I18n.t('answer.failure_destroy')
    end
  end

  private

  def question
    @question ||= Question.find(params[:question_id])
  end
  helper_method :question

  def answers
    @answers ||= question.answers
  end
  helper_method :answers

  def answer
    @answer ||= params[:id].present? ? Answer.find(params[:id]) : answers.build(answer_params)
  end
  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
