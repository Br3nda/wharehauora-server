# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  namespace :web do
    resources :homes
    resources :rooms
    resources :sensors
    resources :readings, only: [:index, :show]
  end

  namespace :api do
    jsonapi_resources :homes
    jsonapi_resources :rooms
    jsonapi_resources :sensors
    # jsonapi_resources :readings
  end
end
