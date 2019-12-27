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

    can %i[update destroy], [Question, Answer], user_id: user.id

    can :vote, [Question, Answer] do |votable|
      votable.user_id != user.id
    end

    can :destroy, Link do |link|
      link.linkable.user_id == user.id
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      attachment.record.user_id == user.id
    end

    can :mark_best, Answer do |answer|
      answer.question.user_id == user.id
    end
  end

  def admin_abilityes
    can :manage, :all
  end
end
