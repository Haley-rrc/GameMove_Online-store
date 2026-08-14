class Order < ApplicationRecord
  belongs_to :customer

  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  # Order status:
  # new -> paid -> shipped
  validates :status,
            presence: true,
            inclusion: { in: %w[new paid shipped] }

  # Saved invoice totals.
  validates :subtotal,
            :tax_rate,
            :tax_amount,
            :total_price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }

  # Save customer information with the order.
  validates :first_name,
            :last_name,
            :email,
            :address,
            :city,
            :postal_code,
            :province_name,
            :province_code,
            presence: true

  validates :email,
            format: {
              with: URI::MailTo::EMAIL_REGEXP
            }

  validates :province_code,
            length: { is: 2 }
end