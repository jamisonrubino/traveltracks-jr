require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "2557307048c8434b91848460d38cffcd", "dea0e75fbc2f414a82fd40ff8b9122c9", scope: 'user-read-email playlist-modify-public user-library-read user-library-modify'
end


# Rails.application.config.middleware.use OmniAuth::Builder do
#   # provider :spotify, keys.spotify["client_id"], keys.spotify["client_secret"], scope: 'playlist-read-private user-read-private user-read-email'
# end
