class CreateServiceReports < ActiveRecord::Migration[7.0]
  def change
    create_table :service_reports do |t|
      t.string :service_report_number, null: false, unique: true
      t.boolean :warranty
      t.string :equipment_model
      t.string :equipment_serial
      t.integer :mischarge
      t.integer :total_charge
      t.string :employee_signature
      t.string :customer_signature
      t.references :service_job, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :service_reports, :discarded_at
  end
end
