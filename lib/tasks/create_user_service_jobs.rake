namespace :populate_db do
  desc 'Create user service jobs'
  task create_user_service_jobs: :environment do

    until UserServiceJob.count == 200 do
      user_id = User.only_technicians.sample.id
      service_job_id = rand(1..ServiceJob.count)

      unless UserServiceJob.exists?(user_id: user_id, service_job_id: service_job_id)
        UserServiceJob.create(user_id: user_id, service_job_id: service_job_id)
      end
    end

  end
end
