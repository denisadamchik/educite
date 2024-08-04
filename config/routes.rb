Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :authors do
        resources :courses, only: %i[index create]
      end

      resources :courses, only: %i[show update destroy]

      resources :skills
    end
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
