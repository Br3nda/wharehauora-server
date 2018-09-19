# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  use_doorkeeper do
    # OAuth applications must be created using rake tasks `rake oauth:application`
    skip_controllers :applications, :authorized_applications
  end

  root 'homes#index'

  resources :homes do
    resources :rooms
    resources :home_viewers
    resources :sensors
    resources :readings
    resources :mqtt_user
  end

  resources :rooms
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
      jsonapi_resources :home_types, only: %i[index show]
      jsonapi_resources :room_types, only: %i[index show]
      jsonapi_resources :users
      jsonapi_resources :sensors
      jsonapi_resources :readings, only: [:show]

      jsonapi_resources :homes do
        jsonapi_resources :rooms, only: [:index]
        jsonapi_resources :sensors, only: [:index]
        jsonapi_resources :readings, only: [:index]
        jsonapi_resources :users
      end
      jsonapi_resources :rooms do
        jsonapi_resources :readings, only: [:index]
      end
    end
  end

  namespace :admin do
    resources :users
    resources :home_types
    resources :room_types
    resources :mqtt_users
  end

  namespace :gateway do
    resources :config
  end
end
