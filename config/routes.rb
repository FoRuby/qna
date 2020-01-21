require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |user| user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root to: 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: :index do
        get :me, on: :collection
      end

      resources :questions, except: %i[new edit] do
         resources :answers, except: %i[new edit], shallow: true
       end
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }
  devise_scope :user do
    post '/fill_email', to: 'oauth_callbacks#fill_email'
  end

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
