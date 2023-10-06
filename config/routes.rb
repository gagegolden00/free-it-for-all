Rails.application.routes.draw do
  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
  end
  devise_for :users
  root "pages#home"

  get "/home", to: "pages#home", as: "home"
  get "/test_page", to: "pages#test_page", as: "test_page"
end

