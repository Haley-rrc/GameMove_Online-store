Rails.application.routes.draw do
  # Customer product pages.
  root "products#index"

  resources :products, only: [:index, :show]
end