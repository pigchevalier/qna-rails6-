Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    collection do
      put :set_best_answer
    end
    resources :votes, only: [:create, :destroy]
    resources :comments, only: [:create]
    resources :answers, shallow: true, only: [:create, :destroy, :update] do
      resources :votes, only: [:create, :destroy]
      resources :comments, only: [:create]
    end
  end

  resources :rewards, only: [:index]
  

  delete 'attachments/:file_id', to: 'attachments#destroy', as: :attachment_destroy
  delete 'links/:id', to: 'links#destroy', as: :link_destroy

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: [:index, :show, :create, :update, :destroy] do
        resources :answers, shallow: true, only: [:show, :create, :update, :destroy]
      end
    end
  end
end
