Rails.application.routes.draw do

  get 'password_resets/new'
  get 'password_resets/create'
  root 'static_pages#home'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/help', to: 'static_pages#help'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get :followers
      get :following
    end
  end

  resources :microposts, only: [:create, :destroy]
  #end
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  post '/relationships', to: 'relationships#create', as: :relationships
  delete '/relationships/:id', to: 'relationships#destroy', as: :relationship

  # resources :relationship, only: [:create, :destroy]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
