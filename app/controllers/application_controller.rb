class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  helper_method :require_login
  before_action :require_login
  
  private
  
  def require_login
      redirect_to root_path unless current_user
  end
end
