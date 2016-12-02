Rails.application.routes.draw do
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
  end

  resources :attachments, only: :destroy
  root to: "questions#index"
  mount ActionCable.server => '/cable'


end
