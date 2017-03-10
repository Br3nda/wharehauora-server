# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'

  resources :homes do
    resources :rooms
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
end
