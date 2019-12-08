module HasVotes
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_by(item)
    if vote = votes.find_by(user: item.user)
      vote.update(value: item.value)
    else
      item.save
    end
  end

  def rating
    votes.sum(:value)
  end
end
