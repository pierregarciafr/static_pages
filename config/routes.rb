Rails.application.routes.draw do
  get 'sessions/new'
  get 'users/new'
  root 'static_pages#home'
  get  '/about', to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'
  get  '/help', to: 'static_pages#help'
  get '/signup', to: 'users#new'
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'

  get 'users/:id/edit', to: 'users#edit'
  patch 'users', to: 'users#update'

  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
