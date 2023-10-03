class CreateCustomerTableAndPoc < ActiveRecord::Migration[7.0]
  def change

    create_table :regions do |t|
      t.string :name
      t.string :manager
      t.timestamps
      t.timestamp :discarded_at
    end

    create_table :customers do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.references :region, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end
    
    create_table :point_of_contacts do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.references :customer, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end

    add_index :regions, :discarded_at
    add_index :customers, :discarded_at
    add_index :point_of_contacts, :discarded_at
  end
end
