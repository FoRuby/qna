class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_context, only: [:create]

  after_action :publish_comment, only: [:create]

  def create
    @comment = @context.comments.new(comment_params)
    @comment.user = current_user
    @comment.save
    flash.now[:success] = 'Comment successfully created.'
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_context
    @context = context_resource.find(context_id)
  end

  def publish_comment
    return if @comment.errors.any?

    data = {
      comment: @comment,
      success: 'There was a new Comment.'
    }
    ActionCable.server.broadcast "question_#{question_id}_comments", data
  end

  def context_resource
    params[:context].classify.constantize
  end

  def context_id
    params.fetch("#{params[:context].foreign_key}")
  end

  def question_id
    return @context.id if @context.is_a?(Question)

    return @context.question.id if @context.is_a?(Answer)
  end
end
