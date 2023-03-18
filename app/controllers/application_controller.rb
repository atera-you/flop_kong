class ApplicationController < ActionController::Base

  def configure_permitted_parameters
    added_attrs = [:email, :password]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
  end

  def home
    if user_signed_in?
      redirect_to user_path(current_user)
    else
      redirect_to new_user_session_path
    end
  end
end
