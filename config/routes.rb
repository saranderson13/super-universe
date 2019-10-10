Rails.application.routes.draw do

  root 'welcome#home'

  # User Paths
  resources :users
  # get '/signup', to: 'users#new'

  # General Paths
  get '/', to: 'welcome#home'

  # Session Paths
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

end
