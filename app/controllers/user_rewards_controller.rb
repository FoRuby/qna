class UserRewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, Reward

    @user_rewards = current_user.rewards
  end
end
