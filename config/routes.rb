# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: 'users/invitations' }
  root 'welcome#index'

  resources :homes do
    resources :home_viewers
    resources :sensors
    resources :users
    resources :readings, only: [:index, :show]
  end

  resources :sensors
  resources :home_viewers

  namespace :admin do
    resources :users
    resources :home_types
    resources :room_types
  end

  get '/api', to: 'api#index'
  namespace :api do
    jsonapi_resources :homes do
      jsonapi_resources :sensors
    end
  end
end
