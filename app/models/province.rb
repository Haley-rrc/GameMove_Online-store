class Province < ApplicationRecord
  has_many :users

  validates :name,
            presence: true,
            length: { minimum: 2, maximum: 50 }

  validates :code,
            presence: true,
            uniqueness: true,
            length: { is: 2 },
            format: { with: /\A[A-Z]{2}\z/ }

  validates :gst_rate,
            :pst_rate,
            :hst_rate,
            presence: true,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 1
            }

  # Add all applicable sales taxes.
  def total_tax_rate
    gst_rate + pst_rate + hst_rate
  end
end