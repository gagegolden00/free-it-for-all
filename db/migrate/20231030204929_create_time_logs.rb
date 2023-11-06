class CreateTimeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :time_logs do |t|
      t.integer :regular_minutes
      t.integer :overtime_minutes
      t.integer :double_time_minutes
      t.integer :mileage
      t.text :remarks
      t.belongs_to :service_report, foreign_key: :true
      t.timestamps
      t.timestamp :discarded_at
    end
  end
end
