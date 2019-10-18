Rails.application.routes.draw do

  # General Paths
  root 'welcome#home'

  # User Paths except '/signup' (instead of 'users#new')
  resources :users, except: [:new] do
    #Character paths, except for 'character/:id/add_powers'
    resources :characters, except: [:index]
  end
  get '/signup', to: 'users#new'

  # Power Paths
  resources :powers, only: [:index, :show]
  post '/characters/add_power', to: 'character_powers#add', as: 'add_power'
  delete '/characters/:id', to: 'character_powers#destroy', as: 'delete_power'



  # Session Paths
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # OAuth Paths
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')
  get 'users/:id/set_alias', to: 'users#set_alias', as: 'set_alias'
  patch 'users/:id/set_alias', to: 'users#oauth_login_complete'

end
