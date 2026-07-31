class Admin::SitePagesController < ApplicationController
  before_action :require_admin
  before_action :set_site_page, only: [:edit, :update]

  def index
    @site_pages = SitePage.order(:page_key)
  end

  def edit
  end

  def update
    if @site_page.update(site_page_params)
      redirect_to admin_site_pages_path,
                  notice: "#{@site_page.title} was updated."
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

  def set_site_page
    @site_page = SitePage.find(params[:id])
  end

  def site_page_params
    params.require(:site_page).permit(
      :title,
      :content
    )
  end
end