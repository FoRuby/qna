class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_many :answers
  has_many :questions

  validates :email, presence: true, uniqueness: true

  def author?(item)
    return false unless item.methods.include?(:user)

    id == item.user_id
  end
end
