class CartController < ApplicationController
  # Show all items currently saved in the cart.
  def show
    cart = session[:cart] || {}

    @cart_items = cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)

      next if product.nil?

      {
        product: product,
        quantity: quantity.to_i,
        item_total: product.price * quantity.to_i
      }
    end.compact

    @cart_total = @cart_items.sum { |item| item[:item_total] }
  end

  # Add one product to the session cart.
  def add
    product = Product.find(params[:product_id])

    session[:cart] ||= {}

    product_id = product.id.to_s
    current_quantity = session[:cart][product_id].to_i

    session[:cart][product_id] = current_quantity + 1

    flash[:notice] = "#{product.name} was added to your cart."
    redirect_to cart_path
  end
end