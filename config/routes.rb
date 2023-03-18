Rails.application.routes.draw do
  root 'users#show'
  devise_for :users
  get 'users/calculation', to: 'users#calculation'
  resources :users, only: [:show]
  resources :span do
    member do
      get 'calculation'
    end
  end
  post '/span/:id/calculation', to: 'span#result'
  
end
