class UsersController < ApplicationController
  def spotify
    puts request.env['omniauth.auth'].credentials.token
    config = {
      :access_token => request.env['omniauth.auth'].credentials.token
    }
    @spotify_user = Spotify::Client.new(config)
    
    # config[:access_token] = request.env['omniauth.auth'].credentials.refresh_token
    
    @id = request.env['omniauth.auth'].extra['raw_info'].id
    
    @playlists = @spotify_user.user_playlists(@id)
    
    puts "#{@spotify_user} #{@id} #{@playlists.pluck(:name)}"
  end
  
  
  def make_playlist
    
    
  end
end
