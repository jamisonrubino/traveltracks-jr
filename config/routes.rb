Rails.application.routes.draw do
  resources :songs
  resources :playlists
  resources :users
  get '/auth/spotify/callback', to: 'users#spotify'
  root "welcome#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
