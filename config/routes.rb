Rails.application.routes.draw do
  # Customer pages.
  root "products#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # admin pages.
  namespace :admin do
    resources :products
  end
end