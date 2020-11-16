Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  devise_for :users, controllers: {
    omniauth_callbacks: 'oauth_callbacks',
    confirmations: 'confirmations' }

  root 'questions#index'

  concern :ratable do
    patch :rate_up, on: :member
    patch :rate_down, on: :member
    delete :cancel_rate, on: :member
  end

  concern :commentable do
    post :create_comment, on: :member
  end

  resources :questions, concerns: %i[ratable commentable], only: %i[index new show create update destroy] do
    resources :answers, concerns: %i[ratable commentable], shallow: true, only: %i[create update destroy] do
      patch :choose_as_best, on: :member
    end
  end

  resources :regards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions, only: %i[index show create update destroy] do
        resources :answers, shallow: true, only: %i[index show create update destroy]
      end
    end
  end
end
