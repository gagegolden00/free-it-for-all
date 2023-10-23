Rails.application.routes.draw do

  get '/up', to: 'up#index', as: :up

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  # Authentication / Registration (may use custom registrations) / Password resets
  devise_for :users

  # Root path (temporary root path)
  root "pages#home"

  # Admin name space, only accessible by mech cool administrators via pundit policies
  namespace :admin, path: '' do
    resources :customers
    resources :service_jobs
    resources :user_service_jobs, only: %i[create destroy]
  end

  # Technician name space only accessable by mech cool technicians
  namespace :technician, path: '' do

  end

end
