class Category < ApplicationRecord
  # One category can have many products.
  has_many :products, dependent: :destroy

  # Category name cannot be empty.
  validates :name, presence: true

  # Category names should not repeat.
  validates :name, uniqueness: true

  # Keep category names at a reasonable length.
  validates :name, length: { minimum: 2, maximum: 50 }
end