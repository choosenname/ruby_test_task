Rails.application.routes.draw do
  get 'categories/index'
  get 'categories/new'
  get 'categories/create'
  get 'categories/edit'
  get 'categories/update'
  get 'categories/destroy'
  root 'users#new'
  get '/signup', to: 'users#new'
  post '/signup', to: 'users#create'
  get '/profile', to: 'users#profile'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users
  resources :events
  resources :categories
end
