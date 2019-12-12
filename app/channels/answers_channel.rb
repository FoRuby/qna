class AnswersChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def follow(data)
    stream_from "question_#{data['question_id']}"
  end
end
