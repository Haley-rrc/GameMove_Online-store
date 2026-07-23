class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items

  validates :status,
            presence: true,
            inclusion: {
              in: %w[pending paid shipped cancelled]
            }

  validates :subtotal,
            :tax_rate,
            :tax_amount,
            :total_price,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0
            }
end