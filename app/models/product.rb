class Product < ApplicationRecord
  # Every product belongs to one category.
  belongs_to :category

  has_one_attached :image

  has_many :order_items
  has_many :orders, through: :order_items

  # Product name is required.
  validates :name, presence: true
  validates :name, length: { minimum: 2, maximum: 100 }

  # Product description is required.
  validates :description, presence: true

  # Price must be greater than zero.
  validates :price, presence: true,
                    numericality: { greater_than: 0 }

  # Stock cannot be a negative number.
  validates :stock_quantity, presence: true,
                             numericality: {
                               only_integer: true,
                               greater_than_or_equal_to: 0
                             }

  scope :new_products, -> {
    where(created_at: 3.days.ago..Time.current)
  }

  scope :recently_updated, -> {
    where(updated_at: 3.days.ago..Time.current)
      .where("created_at < ?", 3.days.ago)
  }
end