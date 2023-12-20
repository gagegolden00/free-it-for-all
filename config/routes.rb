Rails.application.routes.draw do

  get '/up', to: 'up#index', as: :up

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  devise_for :users, skip: :registrations

  resources :users

  root "pages#home"

  resources :customers

  resources :service_jobs do
    resources :service_reports
    resources :purchase_orders
  end

  resources :user_service_jobs, only: %i[create destroy]

  get "time_sheets", to: 'time_sheets#index', as: :time_sheets
  get "time_sheet/:user_id", to: 'time_sheets#show', as: :time_sheet

  get "schedule", to: 'schedule#index', as: :schedule

end
