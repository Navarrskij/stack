Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :questions do
    resources :answers , shallow: true do
    	patch 'best', on: :member
    end
  end
  resources :attachments, only: :destroy
  root to: "questions#index"
end
