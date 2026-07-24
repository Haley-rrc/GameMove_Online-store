class AddCustomerToOrders < ActiveRecord::Migration[7.2]
  def change
    add_reference :orders,
                  :customer,
                  foreign_key: true
  end
end