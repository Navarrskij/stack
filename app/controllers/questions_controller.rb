class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_question, except: [:new, :create, :index]
  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.build

  end

  def new
    @question = Question.new
    @question.attachments.build
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
    if current_user.author_of?(@question)
      @question.update(questions_params)
    else
      render :edit
    end
  end

  def destroy
    
    if current_user.author_of?(@question)
      @question.destroy 
      flash[:notice] = "Question is successfully deleted"
    else
      flash[:notice] = "Permission denide"
    end
      redirect_to questions_path
  end

  private

  def load_question
     @question = Question.find(params[:id])
  end

  def questions_params

    params.require(:question).permit(:title, :body, attachments_attributes: [:file])
  end
end
