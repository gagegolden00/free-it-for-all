Rails.application.routes.draw do

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end

  resources :customers
  devise_for :users
  
  root "pages#home"
end

