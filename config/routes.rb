Rails.application.routes.draw do
  root 'sessions#new'
  resources :cats do
    resources :cat_rental_requests, only: [:index]
  end
  resources :cat_rental_requests, only: [:new, :create]

  patch 'cat_rental_requests/:id/approve' => 'cat_rental_requests#approve', as: 'approve_rental'
  patch 'cat_rental_requests/:id/deny' => 'cat_rental_requests#deny', as: 'deny_rental'

  resources :users, only: [:new, :create]
  resources :sessions, only: [:new, :create, :destroy, :index]
end
