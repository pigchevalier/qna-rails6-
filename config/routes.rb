Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    collection do
      put :set_best_answer
    end
    resources :answers, shallow: true, only: [:create, :destroy, :update]
  end
end
