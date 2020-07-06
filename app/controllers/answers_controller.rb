class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    answer.user = current_user
    answer.save
  end

  def update
    if current_user.author_of?(answer)
      answer.update(answer_params)
    else
      render 'questions/show'
    end
  end

  def destroy
    if current_user.author_of?(answer)
      answer.destroy
    else
      render 'questions/show'
    end
  end

  def choose_as_best
    @question = answer.question

    answer.choose_as_best if current_user.author_of?(@question)
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
