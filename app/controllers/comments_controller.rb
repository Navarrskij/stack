class CommentsController < ApplicationController
	before_action :authenticate_user!
  before_action :set_commentable
  after_action :publish_comment

  respond_to :js

  authorize_resource
 
  def create
    respond_with(@comment = @commentable.comments.create(comment_params.merge(user: current_user)))
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

  def publish_comment
    return if @comment.errors.any?
    question_id = (@comment.commentable_type == 'Question') ? @comment.commentable_id : @comment.commentable.question_id
    ActionCable.server.broadcast("comments_#{question_id}",
      ApplicationController.render(json: { comment: @comment, commentable_type: @commentable.class.name,
      commentable_id: @commentable.id })
    )
  end
end
