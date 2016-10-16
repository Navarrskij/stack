class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  def index
    @questions = Question.all
  end

  def show
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = current_user.questions.build(questions_params)
    if @question.save
      flash[:notice] = "Question successfully created"
      redirect_to @question
    else
      render :new
    end
  end

  def update
    if @question.update(questions_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    @question = current_user.questions.find_by_id(params[:id])
    if @question.present?
      @question.destroy
      flash[:notice] = "Question is successfully deleted"
      redirect_to questions_path
    else
      flash[:notice] = "Permission denide"
      render :index
    end
  end

  private

  def load_question
     @question = Question.find(params[:id])
  end

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end
