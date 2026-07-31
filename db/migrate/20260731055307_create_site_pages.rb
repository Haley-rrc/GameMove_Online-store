class CreateSitePages < ActiveRecord::Migration[7.2]
  def change
    create_table :site_pages do |t|
      t.string :page_key, null: false
      t.string :title, null: false
      t.text :content, null: false

      t.timestamps
    end

    add_index :site_pages, :page_key, unique: true
  end
end