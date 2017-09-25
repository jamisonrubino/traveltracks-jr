Rails.application.routes.draw do
  resources :playlists, only: [:index, :show, :create]
  get '/logout', to: 'users#logout'
  get '/auth/spotify/callback', to: 'users#spotify'
  post '/make_playlist', to: 'playlists#create'
  root "welcome#index"
end
