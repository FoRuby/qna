class OauthCallbacksController < Devise::OmniauthCallbacksController

  before_action :set

  def github
    # @user = User.find_for_oauth(request.env['omniauth.auth'])

    # if @user&.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    # else
    #   redirect_to root_path, alert: 'Something went wrong'
    # end
  end

  def twitter
    render json: request.env['omniauth.auth']
  end

  def yandex
    # @user = User.find_for_oauth(request.env['omniauth.auth'])

    # if @user&.persisted?
    #   sign_in_and_redirect @user, event: :authentication
    #   set_flash_message(:notice, :success, kind: 'Yanex') if is_navigational_format?
    # else
    #   redirect_to root_path, alert: 'Something went wrong'
    # end
  end

  private

  def set
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      if is_navigational_format?
        set_flash_message(:notice, :success,
                          kind: "#{self.action_name.to_s.capitalize}")
      end
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
