class CreateMaterials < ActiveRecord::Migration[7.0]
  def change
    create_table :materials do |t|
      t.string :name, null: false, unique: true
      t.integer :price, null: false
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :materials, :discarded_at
  end
end
