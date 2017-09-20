class UsersController < ApplicationController
  skip_before_action :require_login
  
  def spotify
    session[:spotify_user] = RSpotify::User.new(request.env['omniauth.auth'])
    puts session[:spotify_user].email
    puts session[:spotify_user].saved_tracks
    redirect_to root_path
  end

end