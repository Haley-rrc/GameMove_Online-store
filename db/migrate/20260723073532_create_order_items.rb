class CreateOrderItems < ActiveRecord::Migration[7.2]
  def change
    create_table :order_items do |t|
      t.references :order,
                   null: false,
                   foreign_key: true

      t.references :product,
                   null: false,
                   foreign_key: true

      t.integer :quantity, null: false

      # Save the product price at checkout time.
      t.decimal :unit_price,
                precision: 10,
                scale: 2,
                null: false

      t.decimal :item_total,
                precision: 10,
                scale: 2,
                null: false

      t.timestamps
    end
  end
end