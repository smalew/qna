Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'questions#index'

  concern :ratable do
    patch :rate_up, on: :member
    patch :rate_down, on: :member
    delete :cancel_rate, on: :member
  end

  resources :questions, concerns: [:ratable], only: %i[index new show create update destroy] do
    resources :answers, concerns: [:ratable], shallow: true, only: %i[create update destroy] do
      patch :choose_as_best, on: :member
    end
  end

  resources :regards, only: :index
  resources :attachments, only: :destroy
  resources :links, only: :destroy
end
