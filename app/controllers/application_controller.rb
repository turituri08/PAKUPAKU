class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :sex, :birthday, :user_name, :child_gender, :child_age])
  end
  
  def after_sign_in_path_for(resource)
    user_path(current_user)
  end
  
end
