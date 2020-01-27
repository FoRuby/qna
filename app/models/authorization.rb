class Authorization < ApplicationRecord
  belongs_to :user

  validates :provider, :uid, presence: true
  validates :user, presence: true, uniqueness: { scope: %i[provider uid] }
end
