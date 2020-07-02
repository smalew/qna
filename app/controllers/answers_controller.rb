class AnswersController < ApplicationController
  before_action :authenticate_user!

  def edit
  end

  def create
    answer.user = current_user
    if answer.save
      redirect_to question_path(answer.question), notice: I18n.t('answer.successful_create')
    else
      render 'questions/show', locals: { model: [answer.question, answer] }
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_path(answer.question)
    else
      render :edit
    end
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
