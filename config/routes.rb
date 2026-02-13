require "sidekiq/web"

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/health", to: "health#show"

  post "/jobs/ping", to: "jobs#ping"

  # Sidekiq Web UI (dev only)
  if Rails.env.development?
    mount Sidekiq::Web => "/sidekiq"
  end

  # Legacy (unversioned)
  resources :orders, only: %i[index show create update] do
    post :sync, on: :member
  end

  # Versioned API
  namespace :api do
    namespace :v1 do
      resources :orders, only: %i[index show create update] do
        post :sync, on: :member
      end
    end
  end
end
