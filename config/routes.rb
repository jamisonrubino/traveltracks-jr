Rails.application.routes.draw do
  resources :users
  # resources :songs
  resources :playlists, only: [:index, :show, :new, :create]
  # resources :users
  get '/new_user', to: 'users#new_user'
  get '/auth/spotify/callback', to: 'users#spotify'
  post '/make_playlist', to: 'playlists#create'
  root "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
