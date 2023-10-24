class CreatePurchaseOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_orders do |t|
      t.string :purchase_order_number, null: false, unique: true
      t.string :vendor
      t.integer :cost
      t.text :notes
      t.text :internal_notes
      t.references :service_job, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :purchase_orders, :discarded_at
  end
end
