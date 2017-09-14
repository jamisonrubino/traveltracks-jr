module ApplicationHelper
    # helper_method :

    def current_user
        Spotify::Client.new(access_token: session[:spotify_key]) if session[:spotify_key]
    end
end
