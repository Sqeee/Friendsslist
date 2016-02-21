class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to root_url, :alert => 'You cannot do that.'
    else
      redirect_to new_user_session_path, :alert => 'Please log in.'
    end
  end

  protected def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :profile_picture << :first_name << :last_name
    devise_parameter_sanitizer.for(:account_update) << :profile_picture << :first_name << :last_name
  end
end
