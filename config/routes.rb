Rails.application.routes.draw do

  root 'static_pages#welcome'

  resources :sessions, only: [:create, :destroy]

  get 'reports/:client_id/:year/:month', to: 'reports#show'
end
