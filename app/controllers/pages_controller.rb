class PagesController < ApplicationController
  def about
    @page = SitePage.find_by!(page_key: "about")
  end

  def contact
    @page = SitePage.find_by!(page_key: "contact")
  end
end