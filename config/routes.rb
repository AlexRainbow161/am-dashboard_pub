Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'login' => 'sessions#delete'
  get 'reports/jobs_all' => 'reports#jobs_all'
  root :to => 'stores#index'
  resources :user do
    resources :jobs
    resources :events
  end
  resources :stores, param: :code do
    resources :jobs do
      resources :patch_panels do
        resources :ports
      end
      resources :photos, only: [:show, :edit, :update, :create, :new, :destroy]
      resources :registrators
    end
  end
  resources :jobs do
    member do
      put 'done'
      put 'accept'
      put 'return_to_work'
    end
    resources :photos, only: [:show, :edit, :update, :create, :new, :destroy]
    resources :patch_panels do
      resources :ports
    end
    resources :registrators
  end
  namespace :admin do
    get 'index' => 'admin#index'
    resources :users
    resources :ldap
    resources :staffs
  end
  resources :reports
  resources :staff, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
