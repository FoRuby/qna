class User < ApplicationRecord
  has_many :answers
  has_many :questions

  validates :email, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  def author?(item)
    return false unless item.respond_to?(:user)

    id == item.user_id
  end
end
