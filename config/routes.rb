Rails.application.routes.draw do

  get 'rewards/index'
  devise_for :users
  root to: 'questions#index'

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]
  resources :rewards, only: [:index]

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_best
      end
    end
  end
end
