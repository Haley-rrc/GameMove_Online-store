class PaymentsController < ApplicationController
  def create
    @order = Order.includes(
      order_items: :product
    ).find(params[:id])

    # Only new orders can be paid.
    unless @order.status == "new"
      redirect_to order_path(@order),
                  alert: "This order cannot be paid."
      return
    end

    # Use saved order prices.
    line_items = @order.order_items.map do |item|
      {
        price_data: {
          currency: "cad",

          product_data: {
            name: item.product.name
          },

          unit_amount:
            (item.unit_price * 100).round.to_i
        },

        quantity: item.quantity
      }
    end

    # Use the saved tax amount.
    if @order.tax_amount.positive?
      line_items << {
        price_data: {
          currency: "cad",

          product_data: {
            name: "Tax"
          },

          unit_amount:
            (@order.tax_amount * 100).round.to_i
        },

        quantity: 1
      }
    end

    stripe_session =
      Stripe::Checkout::Session.create(
        mode: "payment",

        line_items: line_items,

        success_url:
          "#{payment_success_url}?session_id={CHECKOUT_SESSION_ID}",

        cancel_url:
          order_url(@order),

        metadata: {
          order_id: @order.id.to_s
        },

        payment_intent_data: {
          metadata: {
            order_id: @order.id.to_s
          }
        }
      )

    @order.update!(
      stripe_checkout_session_id:
        stripe_session.id
    )

    redirect_to stripe_session.url,
            allow_other_host: true,
            status: :see_other
  end

  def success
    @stripe_session =
      Stripe::Checkout::Session.retrieve(
        params[:session_id]
      )

    @order = Order.find_by(
      stripe_checkout_session_id:
        @stripe_session.id
    )
  end
end