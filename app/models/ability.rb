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

    can :index, User
    can :me, User, user_id: user.id

    can :create, [Question, Answer, Comment]

    can %i[update destroy], [Question, Answer], user_id: user.id

    can :vote, [Question, Answer] do |votable|
      not user.author_of?(votable)
    end

    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end

    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end

    can :mark_best, Answer do |answer|
      user.author_of?(answer.question)
    end

    can :subscribe, Question do |question|
      not user.subscribed_on?(question)
    end

    can :unsubscribe, Question do |question|
      user.subscribed_on?(question)
    end
  end

  def admin_abilityes
    can :manage, :all
  end
end
