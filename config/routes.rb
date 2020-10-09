Rails.application.routes.draw do
  root 'static_pages#home'
  get '/upload',          to: 'static_pages#post'

  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#create'

  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :posts,               only: [:show, :create, :edit, :update, :destroy]
  resources :relationships,       only: [:create, :destroy]

  # 例外
  get '*not_found', to: 'application#routing_error'
  post '*not_found', to: 'application#routing_error'
end
