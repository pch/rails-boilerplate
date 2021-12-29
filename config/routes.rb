require "sidekiq/web"

Rails.application.routes.draw do
  if Rails.env.development?
    # TODO: add admin constraint
    mount Sidekiq::Web => "/sidekiq"
  end

  get "info/terms-of-service", to: "static_pages#terms_of_service", as: :terms
  get "info/privacy-policy", to: "static_pages#privacy_policy", as: :privacy_policy

  root "home#index"
end
