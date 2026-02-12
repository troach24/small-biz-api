require "sidekiq/web"

Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  get "/health", to: "health#show"

  post "/jobs/ping", to: "jobs#ping"

  resources :orders, only: %i[index show create update] do
    post :sync, on: :member
  end

  mount Sidekiq::Web => "/sidekiq"
end
