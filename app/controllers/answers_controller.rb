class AnswersController < ApplicationController
  def create
    #@question = Question.find(params[:id])
    #@answer = @question.answers.create(answer_params)
    #redirect_to question_path(@question)

    @answer = Answer.new(answer_params)
    if @answer.save
      redirect_to @answer
  end

  private

    def answer_params
      params.require(:answer).permit(:body)
    end
  end
end
