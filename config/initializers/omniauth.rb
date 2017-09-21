require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV["CLIENT_ID"], ENV["CLIENT_SECRET"], scope: 'playlist-modify-private user-library-read user-read-birthdate user-read-email playlist-read-private playlist-read-collaborative user-top-read user-read-private'
end