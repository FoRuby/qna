class OauthCallbacksController < Devise::OmniauthCallbacksController
  before_action :set_auth, :set_email, only: %i[github yandex vkontakte]

  def github
    return render 'shared/_oauth_confirm_email' unless @email

    login_with_provider('Github')
  end

  def yandex
    return render 'shared/_oauth_confirm_email' unless @email

    login_with_provider('Yandex')
  end

  def vkontakte
    return render 'shared/_oauth_confirm_email' unless @email

    login_with_provider('Vkontakte')
  end

  def fill_email
    cookies[:email] = params[:email]
    user = User.find_or_create(params[:email])
    confirmed_message(user)
  end

  private

  def set_auth
    @auth = request.env['omniauth.auth']
  end

  def set_email
    @email = @auth.info[:email] || cookies[:email]
  end

  def confirmed_message(user)
    if user.confirmed?
      flash[:success] = 'You can sign in by provider'
      redirect_to user_session_path
    else
      flash[:success] = "We send you email on #{user.email} for confirmation "
      redirect_to user_session_path
    end
  end

  def login_with_provider(provider_name)
    @user = User.find_for_oauth(@auth, @email)

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success,kind: provider_name)
      end
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
