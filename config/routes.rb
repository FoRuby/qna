Rails.application.routes.draw do

  get 'user_rewards/index'
  devise_for :users
  root to: 'questions#index'
  get 'user/rewards', to: 'user_rewards#index'

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_best
      end
    end
  end
end
