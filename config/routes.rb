Rails.application.routes.draw do
  root 'users#show'
  devise_for :users
  get 'users/calculation', to: 'users#calculation'
  resources :users, only: [:show]
  resources :span do
    member do
      get 'calculation'
      post 'result'
      get 'show_result'
    end
  end

end
