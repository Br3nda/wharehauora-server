# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :homes do
    resources :sensors
    resources :users
    resources :readings, only: [:index, :show]
  end

  resources :users
  resources :rooms
  resources :sensors

  post '/homes/:id/add_authorized_viewer', to: 'homes#add_authorized_viewer'

  get '/api', to: 'api#index'

  namespace :api do
    jsonapi_resources :homes do
      jsonapi_resources :sensors
    end
  end
end
