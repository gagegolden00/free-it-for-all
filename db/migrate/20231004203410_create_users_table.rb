class CreateUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_enum :role, %w[admin technician]

    create_table :users do |t|
      t.enum :role, enum_type: 'role', null: false
      t.string :name, null: false
      t.string :home_phone
      t.string :work_phone
      t.string :carrier
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.date :hire_date
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.timestamps
      t.timestamp :discarded_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true

  end
end
