class QuestionsChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def echo(data)
    transmit data
    p data
  end

  def follow(data)
    stream_from 'questions'
  end
end
