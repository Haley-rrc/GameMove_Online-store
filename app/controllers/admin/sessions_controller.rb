class Admin::SessionsController < ApplicationController
  # Show the administrator login form.
  def new
  end

  # Check the username and password.
  def create
    admin = AdminUser.find_by(username: params[:username])

    if admin&.authenticate(params[:password])
      session[:admin_user_id] = admin.id

      redirect_to admin_products_path,
                  notice: "Admin login was successful."
    else
      flash.now[:alert] = "Username or password is incorrect."
      render :new, status: :unprocessable_entity
    end
  end

  # Log the administrator out.
  def destroy
    session.delete(:admin_user_id)

    redirect_to root_path,
                notice: "Admin logout was successful."
  end
end