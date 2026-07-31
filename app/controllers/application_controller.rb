class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters,
                if: :devise_controller?

  protected

  def configure_permitted_parameters
    account_fields = [
      :username,
      :first_name,
      :last_name,
      :email,
      :address,
      :city,
      :postal_code,
      :province_id,
      :password,
      :password_confirmation
    ]

    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: account_fields
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: account_fields
    )
  end
end