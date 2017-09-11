Rails.application.config.middleware.use OmniAuth::Builder do
  provider :spotify, "2557307048c8434b91848460d38cffcd", "dea0e75fbc2f414a82fd40ff8b9122c9", scope: 'playlist-modify-private user-library-read user-read-birthdate user-read-email playlist-read-private'
end

# to pull from user's top artists and tracks, include scope:
# user-top-read