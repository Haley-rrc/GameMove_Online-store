class AddDeviseFieldsToCustomers < ActiveRecord::Migration[7.2]
  def change
    add_column :customers, :username, :string
    add_column :customers, :encrypted_password, :string
  end
end
