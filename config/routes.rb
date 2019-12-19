Rails.application.routes.draw do

  root to: 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  get 'user/rewards', to: 'user_rewards#index'

  concern :voted do
    patch :vote, on: :member
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  resources :questions, concerns: :voted do
    resources :comments, only: [:create], defaults: { context: 'question' }
    resources :answers, concerns: :voted,
                        shallow: true,
                        only: %i[create update destroy] do
      resources :comments, only: [:create], defaults: { context: 'answer' }
      patch :mark_best, on: :member
    end
  end
end
