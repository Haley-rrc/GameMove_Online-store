class ProductsController < ApplicationController
  # Show all products on the store page.
  def index
    @products = Product.includes(:category).order(:name)
  end

  # Show one selected product.
  def show
    @product = Product.find(params[:id])
  end
end