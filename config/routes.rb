Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'login' => 'sessions#delete'
  root :to => 'stores#index'
  resources :user do
    resources :jobs
  end
  resources :stores, param: :code do
    resources :jobs
  end
  resources :jobs
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
