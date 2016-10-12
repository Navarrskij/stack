class QuestionsController < ApplicationController
  def index
    @questions = Question.all
  end

  def show
    @Question = Question.find(params[:id])
  end
end
