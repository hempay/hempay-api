# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :v1 do
    resources :users, only: %i[show create] do
      collection do
        get :me
      end
    end
  end


  devise_for :users, skip: [:sessions, :registrations, :passwords], controllers: {
  sessions: 'v1/users/sessions',
  registrations: 'v1/users/registrations',
  passwords: 'v1/users/passwords'
}, path: 'auth', path_names: { sign_in: 'login', sign_out: 'logout', registration: 'signup' }

# Manually define the routes for the skipped controllers
as :user do
  post 'auth/login', to: 'v1/users/sessions#create', as: :user_session
  delete 'auth/logout', to: 'v1/users/sessions#destroy', as: :destroy_user_session
  post 'auth/signup', to: 'v1/users/registrations#create', as: :user_registration
  put 'auth/password/reset', to: 'v1/users/passwords#update', as: :update_user_password
  post 'auth/password/forgot', to: 'v1/users/passwords#create', as: :forgot_user_password
end
end
