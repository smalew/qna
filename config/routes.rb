Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

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
end
