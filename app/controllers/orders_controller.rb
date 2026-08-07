class OrdersController < ApplicationController
  before_action :require_admin, only: [:index]

  before_action :set_order, only: [:show]
  before_action :require_order_access, only: [:show]

  # Admin can see all orders.
  def index
    @orders = Order.includes(
      :customer,
      order_items: :product
    ).order(created_at: :desc)
  end

  # Logged-in customer can see their own past orders.
  def my_orders
    unless customer_signed_in?
      redirect_to new_customer_session_path,
                  alert: "Please log in to view your orders."
      return
    end

    @orders = current_customer.orders
                              .includes(order_items: :product)
                              .order(created_at: :desc)
  end

  # Show one order.
  def show
    # Remove one-time checkout access after it is used.
    if !admin_logged_in? &&
       !customer_signed_in?
      session.delete(:new_order_id)
    end
  end

  private

  def set_order
    @order = Order.includes(
      :customer,
      order_items: :product
    ).find(params[:id])
  end

  def admin_logged_in?
    session[:admin_user_id].present?
  end

  def require_admin
    return if admin_logged_in?

    redirect_to admin_login_path,
                alert: "Please log in as admin to view all orders."
  end

  def require_order_access
    # Admin can see every order.
    return if admin_logged_in?

    # Logged-in customer can only see their own order.
    if customer_signed_in? &&
       @order.customer_id == current_customer.id
      return
    end

    # Guest can view the order immediately after checkout once.
    if session[:new_order_id].to_i == @order.id
      return
    end

    redirect_to root_path,
                alert: "You do not have access to this order."
  end
end