class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]

  before_action :load_question, only: :create
  before_action :desc_best_answer, only: :best

  respond_to :js
  respond_to :json, only: :best

  authorize_resource

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def edit
  end

  def update
    @answer.update(answer_params)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy)
  end

  def best
    @answer.best!
    respond_with(@answer)
  end

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def load_question
    @question = Question.find(params[:question_id])
  end

  def desc_best_answer
    @answers = @answer.question.answers.order(best: :desc)
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end


end
