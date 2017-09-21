class UsersController < ApplicationController
  skip_before_action :require_login
  
  def spotify
    session[:spotify_user] = RSpotify::User.new(request.env['omniauth.auth'])
    session[:spotify_user_name] = session[:spotify_user].display_name
    
    puts session[:spotify_user_name]
    puts session[:spotify_user].email
    puts session[:spotify_user].saved_tracks(limit: 50, offset: 0)
    
    session[:saved_tracks] = []
    
    session[:spotify_user].saved_tracks(limit: 50, offset: 0).each do |t|
      session[:saved_tracks] << t
    end
    session[:spotify_user].saved_tracks(limit: 50, offset: 50).each do |t|
      session[:saved_tracks] << t
    end
    session[:spotify_user].saved_tracks(limit: 50, offset: 100).each do |t|
      session[:saved_tracks] << t
    end
    redirect_to root_path
  end
  
  def logout
    reset_session
    redirect_to root_path
  end

end