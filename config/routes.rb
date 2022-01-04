require "sidekiq/web"

Rails.application.routes.draw do
  if Rails.env.development?
    # TODO: add admin constraint
    mount Sidekiq::Web => "/sidekiq"
  end

  namespace :users do
    resources :signups, only: %i[new create]
    resources :sessions, only: %i[new create destroy]
    resources :password_resets, only: %i[new create edit update]
    resources :email_confirmations, only: %i[index show create]

    resource :user, only: %i[edit update destroy]
  end

  get "sign-up", to: "users/signups#new", as: :signup
  get "log-in", to: "users/sessions#new", as: :login
  delete "log-out", to: "users/sessions#destroy", as: :logout

  get "info/terms-of-service", to: "static_pages#terms_of_service", as: :terms
  get "info/privacy-policy", to: "static_pages#privacy_policy", as: :privacy_policy

  root "home#index"
end
