Rails.application.routes.draw do
  resources :authors do
    resources :courses, only: %i[index create]
  end

  resources :courses, only: %i[show update destroy]

  resources :skills

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
end
