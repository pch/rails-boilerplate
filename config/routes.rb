# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "info/terms-of-service", to: "static_pages#terms_of_service", as: :terms
  get "info/privacy-policy", to: "static_pages#privacy_policy", as: :privacy_policy

  root "home#index"
end
