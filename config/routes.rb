require 'sidekiq/web'

Rails.application.routes.draw do

  get '/up', to: 'up#index', as: :up

  if Rails.env.development?
    mount Lookbook::Engine, at: "/lookbook"
    mount Sidekiq::Web, at: "/sidekiq"
  end

  devise_for :users

  root "pages#show"

  resources :ipv4_quizzes
end
