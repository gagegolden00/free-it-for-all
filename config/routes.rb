Rails.application.routes.draw do

  # Lookbook development tool routing
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
  end

  # Technician namespacem only accessable by mech cool technicians
  namespace :technician, path: '' do
    
  end

end

