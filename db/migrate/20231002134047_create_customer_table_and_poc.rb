class CreateCustomerTableAndPoc < ActiveRecord::Migration[7.0]
  def change
    create_table :point_of_contact do |t|
      t.string :name
      t.string :phone_number
      t.string :email

      t.timestamps
      t.timestamp :discarded_at
    end

    create_table :customer_tables do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :email
      t.string :address
      t.string :city
      t.string :state
      t.integer :zipcode

      t.timestamps
      t.timestamp :discarded_at

      t.references :point_of_contact
    end


  end
end
