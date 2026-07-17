class ProductsController < ApplicationController
  # Show products on the store homepage.
  def index
    products = Product.includes(:category).order(:name)

    # Total number of products.
    @product_count = products.count

    # Show 12 products on each page.
    @pagy, @products = pagy(:offset, products, limit: 12)
  end

  # Show one selected product.
  def show
    @product = Product.find(params[:id])
  end
end