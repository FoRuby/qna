# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilityes : user_abilityes
    else
      guest_abilityes
    end
  end

  def guest_abilityes
    can :read, :all
  end

  def user_abilityes
    guest_abilityes
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
  end

  def admin_abilityes
    can :manage, :all
  end
end
