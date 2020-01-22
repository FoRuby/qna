class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    authorize! :subscribe, question

    @question.subscribe(current_user)
  end

  def destroy
    authorize! :unsubscribe, question

    @question.unsubscribe(current_user)
  end

  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end
end
