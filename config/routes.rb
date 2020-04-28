Rails.application.routes.draw do

  root 'static_pages#home'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/help', to: 'static_pages#help'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  # get '/account_activations', to:'account_activations#edit'

  resources :users
  resources :account_activations, only: [:edit]
  # get '/users/:id/edit', to: 'users#edit', as: :edit_user
  # patch '/users/:id', to: 'users#update', as: :update_user

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
