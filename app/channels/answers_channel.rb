class AnswersChannel < ApplicationCable::Channel
  def subscribed
    stream_for question
  end

  def unsubscribed
  end

  def question
    Question.find_by(id: params[:question_id])
  end
end
