ActiveAdmin.register SitePage do
  menu label: "Website Pages"

  actions :index, :edit, :update

  permit_params :title, :content

  config.filters = false

  index do
    selectable_column
    id_column

    column :page_key
    column :title
    column :updated_at

    actions defaults: false do |page|
      link_to "Edit", edit_admin_site_page_path(page)
    end
  end

  form do |form|
    form.semantic_errors

    form.inputs "Page Content" do
      form.input :page_key,
                 input_html: { disabled: true }

      form.input :title

      form.input :content,
                 as: :text,
                 input_html: { rows: 15 }
    end

    form.actions
  end

  controller do
    def update
      if resource.update(permitted_params[:site_page])
        redirect_to admin_site_pages_path,
                    notice: "#{resource.title} was updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end
  end
end