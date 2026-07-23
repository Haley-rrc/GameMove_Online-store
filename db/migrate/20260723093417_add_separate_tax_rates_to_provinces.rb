class AddSeparateTaxRatesToProvinces < ActiveRecord::Migration[7.2]
  def change
    add_column :provinces,
               :gst_rate,
               :decimal,
               precision: 6,
               scale: 5,
               null: false,
               default: 0

    add_column :provinces,
               :pst_rate,
               :decimal,
               precision: 6,
               scale: 5,
               null: false,
               default: 0

    add_column :provinces,
               :hst_rate,
               :decimal,
               precision: 6,
               scale: 5,
               null: false,
               default: 0
  end
end