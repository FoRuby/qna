class AnswerRewardService
  attr_reader :user

  def initialize(answer)
    @reward = answer.question.reward
    @user = answer.user
  end

  def reward
    @reward.update(user: user) if @reward.present?
  end
end
