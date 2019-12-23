class User < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :rewards, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  validates :email, presence: true, uniqueness: true

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable,
         :confirmable,
         :omniauthable, omniauth_providers: %i[github yandex vkontakte]

  def self.find_for_oauth(auth, email)
    FindForOauthService.new(auth, email).call
  end

  def self.find_or_create!(email)
    user = User.find_by(email: email)
    user || create_user_with_rand_password!(email)
  end

  def self.create_user_with_rand_password!(email)
    password = Devise.friendly_token[0, 20]
    User.create!(
      email: email,
      password: password,
      password_confirmation: password
    )
  end

  def author?(item)
    return false unless item.respond_to?(:user)

    id == item.user_id
  end
end
