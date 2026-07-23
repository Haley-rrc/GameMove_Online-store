class OrdersController < ApplicationController
  # Show one completed order.
  def show
    @order = Order.includes(
      order_items: :product
    ).find(params[:id])
  end
end