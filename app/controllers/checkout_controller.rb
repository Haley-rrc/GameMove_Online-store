class CheckoutController < ApplicationController
  before_action :require_cart

  # Show the customer information form.
  def new
    @user = User.new
    load_cart
  end

  # Show the order invoice before saving the order.
  def review
    @user = User.new(user_params)
    load_cart

    unless @user.valid?
      render :new, status: :unprocessable_entity
      return
    end

    @province = @user.province
    calculate_totals

    # Temporarily save customer information in the session.
    session[:checkout_user] = user_params.to_h
  end

  # Save the customer, order and order items.
  def complete
    checkout_data = session[:checkout_user]

    unless checkout_data.present?
      redirect_to checkout_path,
                  alert: "Please enter your checkout information."
      return
    end

    load_cart

    # Find an existing customer by email, or create a new one.
    email = checkout_data["email"].strip.downcase

    @user = User.where("LOWER(email) = ?", email).first_or_initialize

    # Update the customer's current address information.
    @user.assign_attributes(checkout_data)

    @province = @user.province
    calculate_totals

    ActiveRecord::Base.transaction do
      # Save customer information.
      @user.save!

      # Save the main order.
      @order = @user.orders.create!(
        status: "pending",
        subtotal: @subtotal,
        tax_rate: @province.tax_rate,
        tax_amount: @tax_amount,
        total_price: @total_price
      )

      # Save every product in the order.
      @cart_items.each do |item|
        product = item[:product]
        quantity = item[:quantity]

        # Stop checkout when there is not enough stock.
        if quantity > product.stock_quantity
          raise StandardError,
                "#{product.name} does not have enough stock."
        end

        @order.order_items.create!(
          product: product,
          quantity: quantity,
          unit_price: product.price,
          item_total: item[:item_total]
        )

        # Reduce stock after the order is saved.
        product.update!(
          stock_quantity: product.stock_quantity - quantity
        )
      end
    end

    # Clear shopping cart and checkout information.
    session.delete(:cart)
    session.delete(:checkout_user)

    redirect_to order_path(@order),
                notice: "Your order was placed successfully."
  rescue ActiveRecord::RecordInvalid => error
    redirect_to checkout_path,
                alert: error.record.errors.full_messages.to_sentence
  rescue StandardError => error
    redirect_to cart_path,
                alert: error.message
  end

  private

  # Prevent checkout when the shopping cart is empty.
  def require_cart
    return if session[:cart].present?

    redirect_to cart_path,
                alert: "Your shopping cart is empty."
  end

  # Read shopping cart data from the session.
  def load_cart
    cart = session[:cart] || {}

    @cart_items = cart.map do |product_id, quantity|
      product = Product.find_by(id: product_id)

      next if product.nil?

      quantity = quantity.to_i

      {
        product: product,
        quantity: quantity,
        item_total: product.price * quantity
      }
    end.compact

    @subtotal = @cart_items.sum do |item|
      item[:item_total]
    end
  end

  # Calculate tax and final order price.
  def calculate_totals
    @tax_amount = (@subtotal * @province.tax_rate).round(2)
    @total_price = @subtotal + @tax_amount
  end

  # Only allow customer checkout fields.
  def user_params
    params.require(:user).permit(
      :first_name,
      :last_name,
      :email,
      :address,
      :city,
      :postal_code,
      :province_id
    )
  end
end