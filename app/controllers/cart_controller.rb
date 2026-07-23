class CartController < ApplicationController
  # Show all items saved in the shopping cart.
  def show
    load_cart_items
  end

  # Add one product to the cart.
  def add
    product = Product.find(params[:product_id])

    session[:cart] ||= {}

    product_id = product.id.to_s
    current_quantity = session[:cart][product_id].to_i

    session[:cart][product_id] = current_quantity + 1

    flash[:notice] = "#{product.name} was added to your cart."
    redirect_to cart_path
  end

  # Update the quantity of one cart item.
  def update
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    session[:cart] ||= {}

    if quantity < 1
      flash[:alert] = "Quantity must be at least 1."
    elsif quantity > product.stock_quantity
      flash[:alert] = "Not enough stock is available."
    else
      session[:cart][product.id.to_s] = quantity
      flash[:notice] = "#{product.name} quantity was updated."
    end

    redirect_to cart_path
  end

  # Remove one product from the cart.
  def remove
    product = Product.find(params[:product_id])

    session[:cart] ||= {}
    session[:cart].delete(product.id.to_s)

    flash[:notice] = "#{product.name} was removed from your cart."
    redirect_to cart_path
  end

  private

  # Build cart item data for the cart page.
  def load_cart_items
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
end