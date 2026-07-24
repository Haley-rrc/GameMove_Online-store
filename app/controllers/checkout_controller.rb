class CheckoutController < ApplicationController
  before_action :require_cart

  # Show the customer information form.
  def new
    @customer = Customer.new
    load_cart
  end

  # Show the invoice before saving the order.
  def review
    @customer = Customer.new(customer_params)
    load_cart

    unless @customer.valid?
      render :new, status: :unprocessable_entity
      return
    end

    @province = @customer.province
    calculate_totals

    # Temporarily save checkout information.
    session[:checkout_customer] = customer_params.to_h
  end

  # Save the customer, order and order items.
  def complete
    checkout_data = session[:checkout_customer]

    unless checkout_data.present?
      redirect_to checkout_path,
                  alert: "Please enter your checkout information."
      return
    end

    load_cart

    # Create a new customer for this checkout.
    @customer = Customer.new(checkout_data)

    @province = @customer.province
    calculate_totals

    ActiveRecord::Base.transaction do
      # Save the customer in the customers table.
      @customer.save!

      # Save the order and associate it with the customer.
      @order = @customer.orders.create!(
        status: "pending",

        # Save address details with the order.
        first_name: @customer.first_name,
        last_name: @customer.last_name,
        email: @customer.email,
        address: @customer.address,
        city: @customer.city,
        postal_code: @customer.postal_code,
        province_name: @province.name,
        province_code: @province.code,

        # Save invoice totals.
        subtotal: @subtotal,
        tax_rate: @province.total_tax_rate,
        tax_amount: @tax_amount,
        total_price: @total_price
      )

      # Save every product in the order.
      @cart_items.each do |item|
        product = item[:product]
        quantity = item[:quantity]

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

        product.update!(
          stock_quantity: product.stock_quantity - quantity
        )
      end
    end

    # Allow one-time access to the new order.
    session[:new_order_id] = @order.id

    # Clear checkout data.
    session.delete(:cart)
    session.delete(:checkout_customer)

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

  # Prevent checkout when the cart is empty.
  def require_cart
    return if session[:cart].present?

    redirect_to cart_path,
                alert: "Your shopping cart is empty."
  end

  # Read shopping cart information.
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

  # Calculate GST, PST/QST and HST.
  def calculate_totals
    @gst_amount =
      (@subtotal * @province.gst_rate).round(2)

    @pst_amount =
      (@subtotal * @province.pst_rate).round(2)

    @hst_amount =
      (@subtotal * @province.hst_rate).round(2)

    @tax_amount =
      @gst_amount + @pst_amount + @hst_amount

    @total_price =
      @subtotal + @tax_amount
  end

  # Only allow customer checkout fields.
  def customer_params
    params.require(:customer).permit(
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