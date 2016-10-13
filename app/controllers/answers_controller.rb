class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    @answer = Answer.new(answer_params.merge(question: @question))
    if @answer.save
      redirect_to @question
    else
      render 'questions/show'
    end
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
end
