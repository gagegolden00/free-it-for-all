class AddServiceJobs < ActiveRecord::Migration[7.0]
  def change

    create_table :work_sites do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :city
      t.string :state
      t.integer :zipcode
      t.string :email
      t.string :phone_number
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :work_sites, :discarded_at

    create_enum :status, ['Pending', 'Not started', 'In progress', 'On hold', 'Completed']

    create_table :service_jobs do |t|
      t.string :job_number, null: false, unique: true
      t.enum :status, enum_type: 'status', null: false, default: 'Pending'
      t.text :description
      t.decimal :contract_amount
      t.string :work_type
      t.references :customer, foreign_key: true
      t.belongs_to :work_site, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end
    add_index :service_jobs, :discarded_at
  end
end
