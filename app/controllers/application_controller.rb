# frozen_string_literal: true rubocopの導入後デフォルトで付いた（Ruby3.0からfrozen trueがデフォルトになるので互換性を保つため）

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name sex birthday user_name child_gender child_age])
  end

  def after_sign_in_path_for(_resource)
    user_path(current_user)
  end
end
