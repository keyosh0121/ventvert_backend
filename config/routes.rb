# frozen_string_literal: true

Rails.application.routes.draw do
  resources :reports
  resources :notifications
  resources :shop_list_items
  resources :schedules
  devise_for :users, only: []
  resource :users, only: [:create]
  resource :login, only: %i[new create], controller: :sessions

  get 'credits/info' => 'credits#info'
  get 'health' => 'sessions#health'
  resources :credits
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
