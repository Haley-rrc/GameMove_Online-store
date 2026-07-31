class AddDeviseFieldsToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :username, :string

    add_column :customers,
               :encrypted_password,
               :string,
               null: false,
               default: ""

    add_index :customers,
              :username,
              unique: true
  end
end