Rails.application.routes.draw do
  # Customer pages.
  root "products#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Administrator pages.
  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :products
  end
end