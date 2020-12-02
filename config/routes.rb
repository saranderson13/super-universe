Rails.application.routes.draw do

  
  # General Paths
  root 'welcome#home'
  
  # News Item Paths
  resources :news_items, except: [:show]
  patch '/update_view', to: 'news_items#update_view'

  # User Paths with custom 'users#new' path: '/signup'
  get '/signup', to: 'users#new'
  resources :users, except: [:new] do
    #Character paths, except for 'character/:id/add_powers'
    resources :characters, except: [:index]
  end
  
  # Dox Paths
  get '/characters/:id/dox', to: 'characters#dox', as: 'dox_form'
  patch '/characters/:id/dox', to: 'characters#dox_char'
  
  # Battle History
  get '/characters/:id/battles', to: 'characters#battles', as: 'battle_history'
  
  # Power Paths
  resources :powers, only: [:index, :show]
  post '/characters/add_power', to: 'character_powers#add', as: 'add_power'
  delete '/characters/:id', to: 'character_powers#destroy', as: 'delete_power'
  
  # Battle paths
  resources :battles, only: [:show, :create, :update]

  # Session Paths
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # OAuth Paths
  get 'auth/:provider/callback', to: 'sessions#googleAuth'
  get 'auth/failure', to: redirect('/')
  get 'users/:id/set_alias', to: 'users#set_alias', as: 'set_alias'
  patch 'users/:id/set_alias', to: 'users#oauth_login_complete'

  # Error Routes
  get '*path', :to => 'errors#routing_error'


end
