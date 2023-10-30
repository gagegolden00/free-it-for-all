class AddUserServiceJobs < ActiveRecord::Migration[7.0]
  def change

    create_table :user_service_jobs do |t|
      t.references :user, null: false
      t.references :service_job, null: false
      t.date :date
      t.time :start_time
      t.time :end_time
      t.timestamps
      t.timestamp :discarded_at
    end

    add_index :user_service_jobs, :discarded_at
    add_index :user_service_jobs, [:user_id, :service_job_id], unique: true
  end

end
