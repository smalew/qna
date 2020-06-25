class AnswersController < ApplicationController
  def index
  end

  def new
    @answer = question.answers.build
  end

  def show
  end

  def edit
  end

  def create
    if answer.save
      redirect_to question_answer_path(question, answer)
    else
      render :new
    end
  end

  def update
    if answer.update(answer_params)
      redirect_to question_answer_path(question, answer)
    else
      render :edit
    end
  end

  def destroy
    answer.destroy

    redirect_to question_answers_path(question)
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
    @answer ||= params[:id].present? ? answers.find(params[:id]) : answers.build(answer_params)
  end
  helper_method :answer

  def answer_params
    params.require(:answer).permit(:body)
  end
end
