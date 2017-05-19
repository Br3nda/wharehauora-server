# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  use_doorkeeper do
    # OAuth applications must be created using rake tasks `rake oauth:new_application`
    skip_controllers :applications, :authorized_applications
  end

  root 'welcome#index'

  resources :homes do
    resources :rooms
    resources :home_viewers
    resources :sensors
    resources :readings
  end

  resources :rooms
  resources :sensors
  resources :messages
  resources :readings
  resources :home_viewers

  namespace :opendata do
    resources :readings, only: [:index]
  end

  namespace :admin do
    get 'cleaner', to: 'cleaner#index'
    delete 'cleaner/rooms', to: 'cleaner#rooms'
    delete 'cleaner/sensors', to: 'cleaner#sensors'
    resources :users
    resources :home_types
    resources :room_types
    resources :mqtt_users
  end
end
