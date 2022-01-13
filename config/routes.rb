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

  delete 'attachments/:file_id', to: 'attachments#destroy', as: :attachment_destroy
end
