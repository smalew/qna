class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: :create

  authorize_resource

  include Rated
  include Commented

  def index
  end

  def show
    question.links.build
    answer.links.build
    gon.question_id = question.id
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_regard
  end

  def create
    question.user = current_user

    if question.save
      redirect_to question, notice: I18n.t('question.successful_create')
    else
      render :new
    end
  end

  def update
    if can? :update, question
      question.update(question_params)
    else
      render :show
    end
  end

  def destroy
    if can?(:destroy, question) && question.destroy
      redirect_to questions_path, notice: I18n.t('question.successful_destroy')
    else
      redirect_to questions_path, alert: I18n.t('question.failure_destroy')
    end
  end

  private

  def publish_question
    return if question.errors.any?

    QuestionsChannel.broadcast_to('questions', question)
  end

  def questions
    @questions ||= Question.all
  end
  helper_method :questions

  def question
    @question ||= params[:id].present? ? Question.find(params[:id]) : Question.new(question_params)
  end
  helper_method :question

  def answers
    @answers ||= question.answers.ordered_by_best
  end
  helper_method :answers

  def answer
    @answer ||= question.answers.build
  end
  helper_method :answer

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [],
                                     regard_attributes: [:title, :image],
                                     links_attributes: [:name, :url, :done, :_destroy])
  end
end
