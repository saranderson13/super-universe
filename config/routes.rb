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
  get '/characters/:id/powers', to: 'character_powers#show'
  delete '/characters/:id/powers', to: 'character_powers#destroy'
  post '/characters/add_power', to: 'character_powers#add', as: 'add_power'
  # get '/characters/:id/add_power', to: 'character_powers#new', as: 'character_add_power'
  # post '/characters/:id/add_power', to: 'character_powers#create'
  # get '/characters/:id/edit_powers', to: 'character_powers#edit', as: 'character_edit_powers'
  # patch '/characters/:id/edit_powers', to: 'character_powers#update'



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
