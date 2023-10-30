Rails.application.routes.draw do

  get '/up', to: 'up#index', as: :up

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  # Authentication / Registration (may use custom registrations) / Password resets
  devise_for :users

  # Root path (temporary root path)
  root "pages#home"

    resources :customers
    resources :service_jobs do
      resources :service_reports
    end
    resources :user_service_jobs, only: %i[create destroy]

end
