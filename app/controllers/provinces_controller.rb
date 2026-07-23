class Admin::ProvincesController < ApplicationController
  before_action :require_admin
  before_action :set_province, only: [:edit, :update]

  # Show all province and territory tax rates.
  def index
    @provinces = Province.order(:name)
  end

  # Show the tax editing form.
  def edit
  end

  # Save new tax rates.
  def update
    if @province.update(province_params)
      # Keep the old combined field synchronized.
      @province.update_column(
        :tax_rate,
        @province.total_tax_rate
      )

      redirect_to admin_provinces_path,
                  notice: "#{@province.name} tax rates were updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_admin
    return if session[:admin_user_id].present?

    redirect_to admin_login_path,
                alert: "Please log in as admin."
  end

  def set_province
    @province = Province.find(params[:id])
  end

  def province_params
    params.require(:province).permit(
      :gst_rate,
      :pst_rate,
      :hst_rate
    )
  end
end