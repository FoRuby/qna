class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true, touch: true

  validates :votable, presence: true
  validates :value, presence: true,
                    inclusion: { in: [-1, 0, 1] }
  validates :user, presence: true,
                   uniqueness: { message: 'has already voted',
                                 scope: %i[votable_id votable_type] }
  validate :voter_can_not_be_votable_author

  private

  def voter_can_not_be_votable_author
    if votable&.user.eql?(user)
      errors.add(:user, "сan't vote for his own #{votable.class}")
    end
  end
end
