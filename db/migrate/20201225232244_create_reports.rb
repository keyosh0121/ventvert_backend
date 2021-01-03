# frozen_string_literal: true

class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.string :category
      t.string :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
