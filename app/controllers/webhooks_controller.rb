class WebhooksController < ApplicationController
  skip_forgery_protection only: :stripe

  def stripe
    payload = request.body.read
    signature = request.env["HTTP_STRIPE_SIGNATURE"]

    begin
      event = Stripe::Webhook.construct_event(
        payload,
        signature,
        ENV["STRIPE_WEBHOOK_SECRET"]
      )
    rescue JSON::ParserError,
           Stripe::SignatureVerificationError
      head :bad_request
      return
    end

    if event.type == "checkout.session.completed"
      stripe_session = event.data.object

      order = Order.find_by(
        id: stripe_session.metadata["order_id"]
      )

      if order && stripe_session.payment_status == "paid"
        order.update!(
          status: "paid",
          stripe_checkout_session_id: stripe_session.id,
          stripe_payment_intent_id: stripe_session.payment_intent
        )
      end
    end

    head :ok
  end
end