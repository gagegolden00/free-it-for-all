class CreateCustomerTableAndPoc < ActiveRecord::Migration[7.0]
  def change
    create_table :regions do |t|
      t.string :name, null: false
      t.string :manager, null: false
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :regions, :discarded_at

    create_table :customers do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zipcode
      t.belongs_to :region
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :customers, :discarded_at

    create_table :point_of_contacts do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :email
      t.belongs_to :customer
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :point_of_contacts, :discarded_at
  end
end
