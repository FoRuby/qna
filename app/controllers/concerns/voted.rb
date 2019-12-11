module Voted
  extend ActiveSupport::Concern

  included do
    before_action :set_votable, only: :vote
  end

  def vote
    @vote = @votable.votes.new(user: current_user, value: params[:value])

    if @votable.vote_by(@vote)
      render 'votes/vote'
    else
      render_errors
    end
  end

  private

  def render_errors
    render json: { errorMessages: @vote.errors.full_messages },
           status: :forbidden
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_votable
    @votable = model_klass.find(params[:id])
  end
end
