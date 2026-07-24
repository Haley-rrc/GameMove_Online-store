class AddAddressDetailsToOrders < ActiveRecord::Migration[7.2]
  def change
    # Save the customer information used for this order.
    add_column :orders, :first_name, :string
    add_column :orders, :last_name, :string
    add_column :orders, :email, :string
    add_column :orders, :address, :text
    add_column :orders, :city, :string
    add_column :orders, :postal_code, :string
    add_column :orders, :province_name, :string
    add_column :orders, :province_code, :string
  end
end