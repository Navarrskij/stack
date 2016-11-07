class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :load_answer, except: [:create]

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.new(answer_params.merge(user: current_user))
    if @answer.save
    end
  end

  def edit
  end

  def update
    if current_user.author_of?(@answer)
      @answer.update(answer_params)
      @question = @answer.question
    end
  end

  def destroy
      if current_user.author_of?(@answer)
      @answer.destroy
    end
  end

  def best
    if current_user.author_of?(@answer.question)
      @answer.best!
    end
    @answers = @answer.question.answers.order(best: :desc)
  end

  def vote_up
    @answer.vote_up(current_user)
  end

  def vote_down
    @answer.vote_down(current_user)
  end  

  private

  def load_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:body, attachments_attributes: [:file])
  end
end
