module HasVotes
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_by(item)
    vote = votes.find_by(user: item.user)
    vote ? vote.update(value: item.value) : item.save
  end

  def rating
    votes.sum(:value)
  end
end
