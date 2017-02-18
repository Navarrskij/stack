class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :create, :index]
  before_action :build_answer, only: :show
  before_action :gon_question_user, only: :show
 
  respond_to :js, only: :update

  authorize_resource

  def index
    respond_with(@questions = Question.all)
  end

  def show
    respond_with @question
  end

  def new
    respond_with (@question = Question.new)
  end

  def edit
  end

  def create
    respond_with (@question = Question.create(questions_params.merge(user: current_user)))
  end

  def update
    @question.update(questions_params)
    respond_with @question
  end

  def destroy
    respond_with(@question.destroy)
  end 

  private

  def load_question
     @question = Question.find(params[:id])
     gon.question_id = @question.id
  end

  def build_answer
    @new_answer = Answer.new(question: @question)
  end

  def questions_params
    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end

  def gon_question_user
    gon.question_user_id = @question.user_id
  end
end
