class OrdersController < ApplicationController
  # Order history is only available to administrators.
  before_action :require_admin, only: [:index]

  # Order details require admin access or one-time customer access.
  before_action :require_order_access, only: [:show]

  # Show all orders to the administrator.
  def index
    @orders = Order.includes(
      :user,
      order_items: :product
    ).order(created_at: :desc)
  end

  # Show one order.
  def show
    @order = Order.includes(
      :user,
      order_items: :product
    ).find(params[:id])

    # Remove customer access after showing the new order once.
    unless admin_logged_in?
      session.delete(:new_order_id)
    end
  end

  private

  # Check whether an administrator is logged in.
  def admin_logged_in?
    session[:admin_user_id].present?
  end

  # Protect the full order history page.
  def require_admin
    return if admin_logged_in?

    redirect_to admin_login_path,
                alert: "Please log in as admin to view orders."
  end

  # Allow admin access or one-time access to the new order.
  def require_order_access
    return if admin_logged_in?

    requested_order_id = params[:id].to_i
    new_order_id = session[:new_order_id].to_i

    return if new_order_id.positive? &&
              requested_order_id == new_order_id

    redirect_to admin_login_path,
                alert: "Please log in as admin to view this order."
  end
end