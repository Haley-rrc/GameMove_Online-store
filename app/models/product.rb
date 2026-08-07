class Product < ApplicationRecord
  # Every product belongs to one category.
  belongs_to :category

  has_one_attached :image

  has_many :order_items
  has_many :orders, through: :order_items

  # Product name is required.
  validates :name,
            presence: true,
            length: {
              minimum: 2,
              maximum: 100
            }

  # Product description is required.
  validates :description,
            presence: true

  # Regular price must be greater than zero.
  validates :price,
            presence: true,
            numericality: {
              greater_than: 0
            }

  # Stock cannot be negative.
  validates :stock_quantity,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than_or_equal_to: 0
            }

  # Sale price must be greater than zero if entered.
  validates :sale_price,
            numericality: {
              greater_than: 0
            },
            allow_nil: true

  validate :sale_price_required_when_on_sale
  validate :sale_price_must_be_lower_than_price

  # Products created in the last 3 days.
  scope :new_products, -> {
    where(created_at: 3.days.ago..Time.current)
  }

  # Products updated recently, but not new products.
  scope :recently_updated, -> {
    where(updated_at: 3.days.ago..Time.current)
      .where("created_at < ?", 3.days.ago)
  }

  # Products currently on sale.
  scope :on_sale, -> {
    where(on_sale: true)
  }

  # Use sale price when product is on sale.
  def current_price
    if on_sale? && sale_price.present?
      sale_price
    else
      price
    end
  end

  private

  def sale_price_required_when_on_sale
    if on_sale? && sale_price.blank?
      errors.add(
        :sale_price,
        "is required when product is on sale"
      )
    end
  end

  def sale_price_must_be_lower_than_price
    return if sale_price.blank? || price.blank?

    if on_sale? && sale_price >= price
      errors.add(
        :sale_price,
        "must be lower than regular price"
      )
    end
  end
end