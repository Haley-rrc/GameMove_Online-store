class Admin::ProvincesController < ApplicationController
  # Only logged-in admins can manage tax rates.
  before_action :require_admin

  # Find the selected province before edit and update.
  before_action :set_province, only: %i[edit update]

  # Show all province and territory tax rates.
  def index
    @provinces = Province.order(:name)
  end

  # Show the edit form.
  def edit
  end

  # Save the updated tax rates.
  def update
    if @province.update(province_params)
      # Keep the old combined tax field updated.
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

  # Require administrator login.
  def require_admin
    return if session[:admin_user_id].present?

    redirect_to admin_login_path,
                alert: "Please log in as admin."
  end

  # Find one province using its ID.
  def set_province
    @province = Province.find(params[:id])
  end

  # Only allow tax rate fields.
  def province_params
    params.require(:province).permit(
      :gst_rate,
      :pst_rate,
      :hst_rate
    )
  end
end