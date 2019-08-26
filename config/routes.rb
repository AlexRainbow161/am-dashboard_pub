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
    resources :photos, only: [:show, :edit, :update, :create, :new]
  end
  namespace :admin do
    get 'index' => 'admin#index'
    resources :users
    resources :ldap
    resources :staffs
  end
  resources :reports
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
