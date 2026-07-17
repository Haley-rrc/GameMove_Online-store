class Admin::ProductsController < ApplicationController
  # Find the product before show, edit, update and destroy.
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  # Show all products in the admin page.
  def index
    @products = Product.includes(:category).order(:name)
  end

  # Show one product.
  def show
  end

  # Show the new product form.
  def new
    @product = Product.new
  end

  # Save a new product.
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_products_path,
                  notice: "Product was added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Show the edit form.
  def edit
  end

  # Save product changes.
  def update
    if @product.update(product_params)
      redirect_to admin_products_path,
                  notice: "Product was updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Delete a product.
  def destroy
    @product.destroy

    redirect_to admin_products_path,
                notice: "Product was deleted successfully."
  end

  private

  # Find one product using its ID.
  def set_product
    @product = Product.find(params[:id])
  end

  # Only allow these form fields.
  def product_params
    params.require(:product).permit(
      :category_id,
      :name,
      :description,
      :price,
      :stock_quantity
    )
  end
end