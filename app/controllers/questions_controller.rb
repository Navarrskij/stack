class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :create, :index]
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
      redirect_to questions_path, notice: "Question successfully created"
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
    @question = current_user.questions.find(params[:id])
    if @question.user_id == current_user.id
      @question.destroy
      redirect_to questions_path, notice: "Question is successfully deleted"
    else
      render :index, notice: "Permission denide"
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
