class CommentsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_context, only: :create
  before_action :set_question, only: :create

  after_action :publish_comment, only: :create

  def create
    @comment = @context.comments.new(comment_params)
    @comment.user = current_user
    flash.now[:success] = 'Comment successfully created.' if @comment.save
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def set_context
    @context = context_resource.find(context_id)
  end

  def context_resource
    params[:context].classify.constantize
  end

  def context_id
    params.fetch("#{params[:context].foreign_key}")
  end

  def set_question
    @question = @context if @context.is_a?(Question)
    @question = @context.question if @context.is_a?(Answer)
    @question
  end

  def publish_comment
    return if @comment.errors.any?

    data = {
      comment: @comment,
      success: 'There was a new Comment.'
    }

    CommentsChannel.broadcast_to(@question, data)
  end
end
