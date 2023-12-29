class RemoveUniqueConstraintFromUserServiceJobs < ActiveRecord::Migration[7.0]
  def change
    remove_index :user_service_jobs, name: 'index_user_service_jobs_on_user_id_and_service_job_id'
  end
end
