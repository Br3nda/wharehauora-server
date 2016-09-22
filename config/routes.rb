# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :homes
  resources :rooms
  resources :sensors

  namespace :api do
    jsonapi_resources :homes
    jsonapi_resources :rooms
    jsonapi_resources :sensors
  end
end
