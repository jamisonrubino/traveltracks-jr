Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, ENV['client_id'], ENV['client_secret'], scope: 'playlist-modify-private user-library-read user-read-birthdate user-read-email playlist-read-private'
end

# to pull from user's top artists and tracks, include scope:
# user-top-read