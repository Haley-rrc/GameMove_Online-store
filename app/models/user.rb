class User < ApplicationRecord
  belongs_to :province
  has_many :orders, dependent: :destroy

  validates :first_name,
            presence: true,
            length: { minimum: 2, maximum: 50 }

  validates :last_name,
            presence: true,
            length: { minimum: 2, maximum: 50 }

  validates :email,
            presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :address,
            presence: true,
            length: { minimum: 5, maximum: 200 }

  validates :city,
            presence: true,
            length: { minimum: 2, maximum: 50 }

  validates :postal_code,
            presence: true,
            format: {
              with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
              message: "must be a valid Canadian postal code"
            }

  validates :province_id,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0
            }
end