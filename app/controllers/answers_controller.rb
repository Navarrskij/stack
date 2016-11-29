class AnswersController < ApplicationController
  include Voted
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]
  after_action :publish_answer, only: :create
  before_action :load_question, only: :create
  before_action :desc_best_answer, only: :best

  respond_to :js
  respond_to :json, only: :best

  def create
    respond_with(@answer = @question.answers.create(answer_params.merge(user: current_user)))
  end

  def edit
  end

  def update
    @answer.update(answer_params) if current_user.author_of?(@answer)
    respond_with(@answer)
  end

  def destroy
    respond_with(@answer.destroy) if current_user.author_of?(@answer)
  end

  def best
    @answer.best! if current_user.author_of?(@answer.question)
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

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast( "answers_#{@question.id}",
      ApplicationController.render(json: { answer: @answer.as_json.merge(rating: @answer.rating), attachments: @answer.attachments })
    )
  end
end
