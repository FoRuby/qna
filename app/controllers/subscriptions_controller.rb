class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question

  def create
    authorize! :subscribe, @question

    @subsciption = @question.subscribe(current_user)
    flash[:success] = 'You successfully subscribed!'
  end

  def destroy
    authorize! :unsubscribe, @question

    @subsciption = @question.unsubscribe(current_user)
    flash[:success] = 'You successfully Unsubscribed'
  end

  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end
end
