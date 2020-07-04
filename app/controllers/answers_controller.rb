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
    current_user.author_of?(answer) && answer.destroy
  end

  def choose_as_best
    question = answer.question
    question.update(best_answer: answer) if current_user.author_of?(question)
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
