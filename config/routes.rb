# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :homes do
    resources :sensors
    resources :users
    resources :readings, only: [:index, :show]
  end

  resources :rooms
  resources :sensors

  namespace :api do
    jsonapi_resources :homes do
      jsonapi_resources :sensors
    end
  end
end
