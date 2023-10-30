class CreateServiceReportMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :service_report_materials do |t|
      t.references :service_report, null: false, foreign_key: :true
      t.references :material, null: false, foreign_key: :true
      t.integer :quantity, null: false
      t.integer :pre_tax_total
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :service_report_materials, [:service_report_id, :material_id], unique: true, name: 'unique_index_on_service_report_and_material'
    add_index :service_report_materials, :discarded_at
  end
end
