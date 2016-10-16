class AnswersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      flash[:notice] = "Answer successfully created"
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = current_user.answers.find_by_id(params[:id])
    @question = Question.find_by_id(params[:question_id])
    if @answer.present?
      @answer.destroy
      flash[:notice] = "Answer is successfully deleted"
      redirect_to question_path(@question)
    else
      flash[:notice] = "Permission denide"
      redirect_to question_path(@question)
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
