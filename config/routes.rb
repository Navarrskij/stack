require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
    
  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  concern :votable do
    member do
      patch 'vote_up'
      patch 'vote_down'
    end
  end
  resources :questions, concerns: [:votable] do
    resources :comments, only: :create
    resources :answers , shallow: true, concerns: [:votable] do
      patch 'best', on: :member
      resources :comments, only: :create
    end
    resources :subscriptions, shallow: true
  end

  resource :search, only: :show
  resources :attachments, only: :destroy
  root to: "questions#index"
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end
      resources :questions do
        resources :answers, shallow: true
      end
    end
  end
  
end
