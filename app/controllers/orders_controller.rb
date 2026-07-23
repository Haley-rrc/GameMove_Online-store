class OrdersController < ApplicationController
  # Only logged-in admins can view orders.
  before_action :require_admin

  def index
    @orders = Order.includes(
      :user,
      order_items: :product
    ).order(created_at: :desc)
  end

  def show
    @order = Order.includes(
      :user,
      order_items: :product
    ).find(params[:id])
  end

  private

  def require_admin
    return if session[:admin_user_id].present?

    redirect_to admin_login_path,
                alert: "Please log in as admin to view orders."
  end
end