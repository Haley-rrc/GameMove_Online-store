class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.text :address, null: false
      t.string :city, null: false
      t.string :postal_code, null: false
      t.references :province,
                   null: false,
                   foreign_key: true

      t.timestamps
    end

    add_index :users, :email
  end
end