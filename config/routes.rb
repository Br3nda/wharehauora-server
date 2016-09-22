Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :homes
  resources :rooms
  resources :sensors
end
