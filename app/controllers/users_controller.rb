class UsersController < ApplicationController
  skip_before_action :require_login
  
  def spotify
    session[:spotify_user] = RSpotify::User.new(request.env['omniauth.auth'])
    redirect_to root_path
  end

end