class Api::V1::QuestionsController < Api::V1::BaseController

  authorize_resource class: Question

  def index
    @questions = Question.all
    respond_with @questions
  end

  def list_questions
    @questions = Question.all
    respond_with @questions
  end

  def show
    @question = Question.find(params[:id])
    respond_with @question, serializer: QuestionAggregateSerializer
  end

  def create
    respond_with (@question = Question.create(questions_params.merge(user: current_resource_owner)))
  end

private

  def questions_params
    params.require(:question).permit(:title, :body)
  end
end