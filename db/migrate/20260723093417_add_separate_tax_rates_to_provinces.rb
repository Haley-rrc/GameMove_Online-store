class AddSeparateTaxRatesToProvinces < ActiveRecord::Migration[7.2]
  def change
    add_column :provinces, :gst_rate, :decimal
    add_column :provinces, :pst_rate, :decimal
    add_column :provinces, :hst_rate, :decimal
  end
end
