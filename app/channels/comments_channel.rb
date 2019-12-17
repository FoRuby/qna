class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "question_#{params[:question_id]}_comments"
  end

  def unsubscribed
  end
end
