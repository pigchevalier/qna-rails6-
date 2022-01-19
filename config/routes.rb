Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    collection do
      put :set_best_answer
    end
    resources :answers, shallow: true, only: [:create, :destroy, :update] do
    end
  end

  resources :rewards, only: [:index]
  resources :votes, only: [:create, :destroy]

  delete 'attachments/:file_id', to: 'attachments#destroy', as: :attachment_destroy
  delete 'links/:id', to: 'links#destroy', as: :link_destroy
end
