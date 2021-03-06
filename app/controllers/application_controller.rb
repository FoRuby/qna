class ApplicationController < ActionController::Base
  before_action :gon_user

  check_authorization unless: :devise_controller?

  private

  def gon_user
    gon.user_id = current_user&.id
  end

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { render status: :forbidden, alert: exception.message }
      format.json { render json: exception.message, status: :forbidden }
    end
  end
end
