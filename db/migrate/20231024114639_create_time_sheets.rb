class CreateTimeSheets < ActiveRecord::Migration[7.0]
  def change
    create_table :time_sheets do |t|
      t.timestamp :start_date, null: false
      t.timestamp :end_date
      t.references :user, foreign_key: :true
      t.integer :regular_minutes
      t.integer :overtime_minutes
      t.integer :double_time_minutes
      t.integer :mileage
      t.text :remarks
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :time_sheets, :discarded_at
  end
end
