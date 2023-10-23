Rails.application.routes.draw do

  get '/up', to: 'up#index', as: :up

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  # Authentication / Registration (may use custom registrations) / Password resets
  devise_for :users

  # Root path (temporary root path)
  root "pages#home"

  # Admin namespace, only accessible by mech cool administrators via pundit policies
  namespace :admin, path: '' do
    resources :customers
    resources :service_jobs
    resources :user_service_jobs, only: %i[create destroy]
  end

  # Technician namespacem only accessable by mech cool technicians
  namespace :technician, path: '' do

  end

  get "/home", to: "pages#home", as: "home"
  get "/test_page", to: "pages#test_page", as: "test_page"

end
