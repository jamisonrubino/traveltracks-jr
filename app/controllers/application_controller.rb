class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :require_login
  before_action :session_expiry

  private
  
  def require_login
    redirect_to root_path unless session['spotify_user'] || request.path == "/"
  end
  
  def session_expiry
    if session[:expires_at]
      if Time.now.to_i > session[:expires_at]
        flash[:alert] = "Your session expired. Please login again."
        redirect_to "/logout"
      end
    end
  end
end
