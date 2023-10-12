class AddServiceJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :salesmen do |t|
      t.string :name, null: false
      t.string :phone_number
      t.string :email
      t.timestamps
      t.timestamp :discarded_at
    end

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

    create_enum :status, %w[status1 status2 status3 completed]

    create_table :service_jobs do |t|
      t.string :job_number, null: false
      t.enum :status, enum_type: "status", null: false
      t.text :description
      t.decimal :contract_amount
      t.string :work_type
      t.references :region, foreign_key: true
      t.references :customer, foreign_key: true
      t.references :salesman, foreign_key: true
      t.references :work_site, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end

    create_table :customer_service_jobs do |t|
      t.references :customer, foreign_key: true
      t.references :service_job, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end

    create_table :purchase_orders do |t|
      t.string :purchase_order_number, null: false
      t.string :vendor
      t.decimal :cost
      t.text :notes
      t.text :internal_notes
      t.references :service_job, foreign_key: true
      t.timestamps
      t.timestamp :discarded_at
    end

    add_index :service_jobs, [:customer_id, :id], unique: true
  end
end
