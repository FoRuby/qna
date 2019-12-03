class UserRewardsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user_rewards = current_user.rewards
  end
end
