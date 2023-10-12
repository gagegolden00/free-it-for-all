class CreateUsersTable < ActiveRecord::Migration[7.0]
  def change
    create_enum :role, %w[admin technician]

    create_table :users do |t|
      t.enum :role, enum_type: 'role', null: false
      t.string :name, null: false
      t.string :home_phone
      t.string :work_phone
      t.string :carrier
      t.date :hire_date
      # Database authenticatable
      t.string :email,              null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      # Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at
      # Rememberable
      t.datetime :remember_created_at
      # created & update timestamps
      t.timestamps
      # Discardable / soft deleteable
      t.timestamp :discarded_at
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    # add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
