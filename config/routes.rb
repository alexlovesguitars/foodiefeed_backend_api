Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :recipes
      resources :users, only: [:create, :show, :index]
      resource :session, only: [:create, :destroy, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
