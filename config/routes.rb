Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'login' => 'sessions#delete'
  get 'reports/jobs_all' => 'reports#jobs_all'
  root :to => 'stores#index'
  resources :user do
    resources :jobs
  end
  resources :stores, param: :code do
    resources :jobs
  end
  resources :jobs do
    member do
      put 'done'
      put 'accept'
    end
  end
  resources :admin do
    collection do
      get "search"
    end
  end
  resources :reports
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
