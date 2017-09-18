class UsersController < ApplicationController
  skip_before_action :require_login
  
  def spotify
    session[:spotify_user] = RSpotify::User.new(request.env['omniauth.auth'])
    session[:auth_token] = requent.env['omniauth.auth'].credentials.token
    # session[:spotify_id] = request.env['omniauth.auth'].extra['raw_info'].id
    redirect_to root_path
  end

end