class CreateCredits < ActiveRecord::Migration[6.0]
  def change
    create_table :credits do |t|
      t.integer :amount
      t.string :content
      t.integer :created_user_id
      t.boolean :credit
      t.boolean :completed

      t.timestamps
    end
  end
end
