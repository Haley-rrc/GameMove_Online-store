class Customer < ApplicationRecord
  belongs_to :province
  has_many :orders, dependent: :destroy

  validates :first_name,
            :last_name,
            :email,
            :address,
            :city,
            :postal_code,
            :province_id,
            presence: true

  validates :email,
            format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :postal_code,
            format: {
              with: /\A[A-Za-z]\d[A-Za-z][ -]?\d[A-Za-z]\d\z/,
              message: "must be a valid Canadian postal code"
            }
end