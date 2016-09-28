# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :homes do
    resources :rooms do
      resources :sensors
    end
    resources :users
    resources :readings, only: [:index, :show]
  end

  resources :sensors

  namespace :api do
    jsonapi_resources :homes
    jsonapi_resources :rooms
    jsonapi_resources :sensors
    # jsonapi_resources :readings
  end
end
