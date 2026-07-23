class Province < ApplicationRecord
  # One province can be used by many customers.
  has_many :users

  validates :name,
            presence: true,
            length: { minimum: 2, maximum: 50 }

  validates :code,
            presence: true,
            uniqueness: true,
            length: { is: 2 },
            format: { with: /\A[A-Z]{2}\z/ }

  validates :tax_rate,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            }
end