Rails.application.routes.draw do
  resources :cats do
    resources :cat_rental_requests, only: [:index]
  end
  resources :cat_rental_requests, except: [:index]
end
