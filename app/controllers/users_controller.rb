class UsersController < ApplicationController
  skip_before_action :require_login
  
  def spotify
    session['spotify_user'] = RSpotify::User.new(request.env['omniauth.auth']).to_hash
    
    session['spotify_user_id'] = session['spotify_user']['id']
    
    puts session['spotify_user_id']
    puts session['spotify_user'].email
    
    # session[:saved_tracks_1] = session['spotify_user'].saved_tracks(limit: 50, offset: 0)
    
    # session[:saved_tracks_2] = session['spotify_user'].saved_tracks(limit: 50, offset: 50)
    
    # session[:saved_tracks_3] = session['spotify_user'].saved_tracks(limit: 50, offset: 100)
    
    puts session[:saved_tracks_1]
    # puts session[:saved_tracks_2]
    # puts session[:saved_tracks_3]
    
    redirect_to root_path
  end
  
  def logout
    reset_session
    redirect_to root_path
  end

end