class ProductsController < ApplicationController
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

    # Feature 2.4 filters.
    case params[:filter]
    when "new"
      @products = @products.new_products

    when "updated"
      @products = @products.recently_updated

    when "sale"
      @products = @products.on_sale
    end




    @product_count = @products.count

    @products = @products
                  .page(params[:page])
                  .per(12)
  end

  def show
    @product = Product.find(params[:id])
  end
end