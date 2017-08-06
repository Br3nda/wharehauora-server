# frozen_string_literal: true

Rails.application.routes.draw do # rubocop:disable Metrics/BlockLength
  devise_for :users
  use_doorkeeper do
    # OAuth applications must be created using rake tasks `rake oauth:application`
    skip_controllers :applications, :authorized_applications
  end

  root 'welcome#index'

  resources :homes do
    resources :rooms
    resources :home_viewers
    resources :sensors
    resources :readings
  end

  resources :rooms do
  end
  resources :sensors do
    delete :unassign, to: 'sensors#unassign'
  end
  resources :messages
  resources :readings
  resources :home_viewers

  namespace :opendata do
    resources :readings, only: [:index]
  end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :homes
      jsonapi_resources :rooms
    end
  end

  namespace :admin do
    get 'cleaner', to: 'cleaner#index'
    delete 'cleaner/rooms', to: 'cleaner#rooms'
    delete 'cleaner/sensors', to: 'cleaner#sensors'
    resources :users
    resources :home_types
    resources :room_types
    resources :mqtt_users
    post :mqtt_sync, to: 'mqtt_users#sync'
  end

  namespace :api do
    resource :user, only: :show
  end
end
