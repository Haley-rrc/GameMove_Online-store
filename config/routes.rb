Rails.application.routes.draw do
  # Store homepage.
  root "products#index"

  # Customer product pages.
  resources :products, only: [:index, :show]

  # Customer category pages.
  resources :categories, only: [:index, :show]
end