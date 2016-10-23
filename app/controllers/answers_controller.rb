class AnswersController < ApplicationController
  before_action :authenticate_user!

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
    end
  end

  def destroy
    @answer = Answer.find(params[:id])
      if current_user.author_of?(@answer)
      @answer.destroy
      flash[:notice] = "Answer is successfully deleted"
    else
      flash[:notice] = "Permission denide"
    end
      redirect_to @answer.question
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
