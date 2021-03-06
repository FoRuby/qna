class Question < ApplicationRecord
  include HasLinks
  include HasVotes
  include HasComments

  belongs_to :user
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  has_many_attached :files

  validates :title, :body, presence: true

  accepts_nested_attributes_for :reward, reject_if: :all_blank, allow_destroy: true

  after_create { subscribe!(user) }

  def subscribe!(user)
    subscriptions.create!(user: user)
  end

  def unsubscribe!(user)
    subscriptions.find_by(user: user).destroy
  end
end
