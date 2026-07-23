class CreateProvinces < ActiveRecord::Migration[7.2]
  def change
    create_table :provinces do |t|
      t.string :name, null: false
      t.string :code, null: false

      # Total sales tax rate, such as 0.13 for Ontario.
      t.decimal :tax_rate,
                precision: 5,
                scale: 4,
                null: false

      t.timestamps
    end

    add_index :provinces, :code, unique: true
  end
end