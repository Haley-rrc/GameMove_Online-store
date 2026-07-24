class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :address
      t.string :city
      t.string :postal_code
      t.references :province, null: false, foreign_key: true

      t.timestamps
    end
  end
end
