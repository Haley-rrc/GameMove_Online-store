class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user,
                   null: false,
                   foreign_key: true

      t.string :status,
               null: false,
               default: "pending"

      # Save totals so future price changes do not affect old orders.
      t.decimal :subtotal,
                precision: 10,
                scale: 2,
                null: false

      t.decimal :tax_rate,
                precision: 5,
                scale: 4,
                null: false

      t.decimal :tax_amount,
                precision: 10,
                scale: 2,
                null: false

      t.decimal :total_price,
                precision: 10,
                scale: 2,
                null: false

      t.timestamps
    end
  end
end