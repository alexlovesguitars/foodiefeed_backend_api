Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :recipes do
        member do
          patch :publish
        end
      end

      resource :user, only: [:create, :update, :destroy]
      resource :session, only: [:create, :destroy, :show]
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
