Rails.application.routes.draw do

  root 'static_pages#welcome'

  resources :sessions, only: [:create, :destroy]

  get 'report', to: 'reports#show', as: 'report'
  get 'reports', to: 'reports#index', as: 'report_home'
end
