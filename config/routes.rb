Rails.application.routes.draw do
  root "products#index"

  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]

  # Shopping cart routes.
  get "cart", to: "cart#show", as: :cart
  post "cart/add/:product_id", to: "cart#add", as: :add_to_cart

  patch "cart/update/:product_id",
        to: "cart#update",
        as: :update_cart_item

  delete "cart/remove/:product_id",
        to: "cart#remove",
        as: :remove_cart_item

  namespace :admin do
    get "login", to: "sessions#new"
    post "login", to: "sessions#create"
    delete "logout", to: "sessions#destroy"

    resources :products
    resources :categories
  end
end