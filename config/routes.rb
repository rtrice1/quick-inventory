Rails.application.routes.draw do
  get 'sessions/new'
  
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :users
  resources :sessions


  get 'dashboard/default'
  root to: 'dashboard#default'
  resources :inventories do
   resources :versions
  end
end
