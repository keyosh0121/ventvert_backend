class CreateShopListItems < ActiveRecord::Migration[6.0]
  def change
    create_table :shop_list_items do |t|
      t.string :content
      t.references :user, null: false, foreign_key: true
      t.string :color
      t.string :icon

      t.timestamps
    end
  end
end
