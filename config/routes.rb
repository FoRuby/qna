Rails.application.routes.draw do

  get 'user_rewards/index'
  devise_for :users
  root to: 'questions#index'
  get 'user/rewards', to: 'user_rewards#index'

  concern :voted do
    member do
      patch :vote_up
      patch :vote_down
      delete :cancel_vote
    end
  end

  resources :attachments, only: [:destroy]
  resources :links, only: [:destroy]

  resources :questions, concerns: :voted do
    resources :answers, concerns: :voted,
                        shallow: true,
                        only: %i[create update destroy] do
      patch :mark_best, on: :member
    end
  end
end
