class ProductsController < ApplicationController
  # Show products on the store homepage.
  def index
    @categories = Category.order(:name)

    @products = Product
                  .includes(:category)
                  .order(:name)

    # Search product title or description.
    if params[:keyword].present?
      keyword = Product.sanitize_sql_like(
        params[:keyword].strip
      )

      @products = @products.where(
        "products.name ILIKE :keyword OR products.description ILIKE :keyword",
        keyword: "%#{keyword}%"
      )
    end

    # Filter products by category.
    if params[:category_id].present?
      @products = @products.where(
        category_id: params[:category_id]
      )
    end

    # Count products before pagination.
    @product_count = @products.count

    @products = @products.page(params[:page]).per(12)
  end

  # Show one selected product.
  def show
    @product = Product.find(params[:id])
  end
end