class CategoriesController < ApplicationController
  # Show all categories.
  def index
    @categories = Category.order(:name)
  end

  # Show one category and its products.
  def show
    @category = Category.find(params[:id])
    @products = @category.products.order(:name)
  end
end