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
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :province_code,
            length: { is: 2 }

  validates :subtotal,
            :tax_rate,
            :tax_amount,
            :total_price,
            presence: true,
            numericality: { greater_than_or_equal_to: 0 }
end