Rails.application.routes.draw do

  # General Paths
  root 'welcome#home'

  # User Paths
  resources :users, except: [:new] do
    resources :characters, except: [:index]
  end
  get '/signup', to: 'users#new'

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
