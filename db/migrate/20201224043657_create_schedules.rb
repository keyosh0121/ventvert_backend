class CreateSchedules < ActiveRecord::Migration[6.0]
  def change
    create_table :schedules do |t|
      t.string :content
      t.date :date
      t.time :time
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
