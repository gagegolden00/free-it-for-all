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
      t.sting :city
      t.string :state
      t.integer :zipcode
      t.string :email
      t.sting :phone_number
      t.timestamps
      t.timestamp :discarded_at
    end

    create_table :purchase_orders do |t|
      t.string :purchase_order_number, null: false
      t.string :vendor
      t.numberic :cost
      t.text :notes
      t.text :internal_notes
      t.timestamps
      t.timestamp :discarded_at
    end


    create_enum :status, %w[status1 status2 status3 completed]

    create_table :service_jobs do |t|
      t.string :job_number, null: false
      t.enum :status, enum_type: "status", null: false
      t.text :description
      t.numeric :contract_amount
      t.sting :work_type

    end
  end
end
