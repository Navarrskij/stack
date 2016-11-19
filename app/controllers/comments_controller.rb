class CommentsController < ApplicationController
		before_action :authenticate_user!
    before_action :set_commentable
 
  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    @comment.save
 
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_commentable
    if params[:question_id].present?
      @commentable = Question.find(params[:question_id])
    elsif params[:answer_id].present?
      @commentable = Answer.find(params[:answer_id])
    end
  end

  #def model_klass
    #commentable_type.classify.constantize
  #end

  #def commentable_type
    #params[:comment][:commentable_type].downcase
  #end

  #def set_commentable
    #@commentable = model_klass.find(params["#{commentable_type}_id"])
  #end
end
