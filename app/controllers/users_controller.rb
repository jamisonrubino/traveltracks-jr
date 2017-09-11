class UsersController < ApplicationController
  def spotify
    config = {
      :access_token => request.env['omniauth.auth'].credentials.token,
      :raise_errors => true,  # choose between returning false or raising a proper exception when API calls fails
      # Connection properties
      :retries       => 0,    # automatically retry a certain number of times before returning
      :read_timeout  => 10,   # set longer read_timeout, default is 10 seconds
      :write_timeout => 10,   # set longer write_timeout, default is 10 seconds
      :persistent    => false # when true, make multiple requests calls using a single persistent connection. Use +close_connection+ method on the client to manually clean up sockets
    }
    puts request.env['omniauth.auth'].credentials
    spotify_user = Spotify::User.new(config)
    puts spotify_user
    # Now you can access user's private data, create playlists and much more
    # hash = spotify_user.to_hash

    # # Access private data
    # spotify_user.country #=> "US"
    # spotify_user.email   #=> "example@email.com"

    # # Create playlist in user's Spotify account
    # playlist = spotify_user.create_playlist!('my-awesome-playlist')
    #
    # # Add tracks to a playlist in user's Spotify account
    # tracks = RSpotify::Track.search('Know')
    # playlist.add_tracks!(tracks)
    # playlist.tracks.first.name #=> "Somebody That I Used To Know"
    #
    # # Access and modify user's music library
    # spotify_user.save_tracks!(tracks)
    # spotify_user.saved_tracks.size #=> 20
    # spotify_user.remove_tracks!(tracks)
    #
    # albums = RSpotify::Album.search('launeddas')
    # spotify_user.save_albums!(albums)
    # spotify_user.saved_albums.size #=> 10
    # spotify_user.remove_albums!(albums)
    #
    # # Use Spotify Follow features
    # spotify_user.follow(playlist)
    # spotify_user.follows?(artists)
    # spotify_user.unfollow(users)
    #
    # # Get user's top played artists and tracks
    # spotify_user.top_artists #=> (Artist array)
    # spotify_user.top_tracks(time_range: 'short_term') #=> (Track array)

    # Check doc for more
  end
end
