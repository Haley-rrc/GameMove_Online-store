module ApplicationHelper
  # Count all product quantities in the session cart.
  def cart_item_count
    cart = session[:cart] || {}

    cart.values.sum(&:to_i)
  end
end