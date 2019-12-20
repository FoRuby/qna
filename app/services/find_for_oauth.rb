class Services::FindForOauth
  attr_reader :auth, :email

  def initialize(auth, email)
    @auth = auth
    @email = email
  end

  def call
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    user = User.find_or_create(email)
    user.authorizations.create!(provider: auth.provider, uid: auth.uid)
    user
  end
end
