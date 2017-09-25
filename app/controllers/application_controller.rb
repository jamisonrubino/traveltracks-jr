class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  before_action :require_login

  private
  
  def require_login
    redirect_to root_path unless session['spotify_user'] || request.path == "/"
  end
  
  def session_expiry
    # if Time.current > session[:expires_at].to_time
    #   flash[:alert] = "Your session expired. Please login again."
    #   redirect_to "/logout"
    # end
  end
end
