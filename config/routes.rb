Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  resources :questions do
    collection do
      put :set_best_answer
      delete :delete_file_attachment
    end
    resources :answers, shallow: true, only: [:create, :destroy, :update] do
      collection do
        delete :delete_file_attachment
      end
    end
  end
end
