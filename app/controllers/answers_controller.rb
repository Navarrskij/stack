class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
      redirect_to @question, notice: "Answer successfully created"
    else
      render 'questions/show'
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
      if @answer.user_id == current_user.id
      @answer.destroy
      redirect_to @answer.question, notice: "Answer is successfully deleted"
    else
      redirect_to @question, notice: "Permission denide"
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
