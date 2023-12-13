namespace :populate_db do
  desc 'Create user service jobs'
  task create_user_service_jobs: :environment do
    until UserServiceJob.count == 200
      user_id = User.only_technicians.sample.id
      service_job_id = ServiceJob.all.sample.id

      UserServiceJob.create(user_id:, service_job_id:) unless UserServiceJob.exists?(user_id:, service_job_id:)

    end
  end
end
