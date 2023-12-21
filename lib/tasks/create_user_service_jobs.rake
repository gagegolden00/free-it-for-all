namespace :populate_db do
  desc 'Create user service jobs'
  task create_user_service_jobs: :environment do
    allowed_time_inputs = [
      '00:00', '00:15', '00:30', '00:45',
      '01:00', '01:15', '01:30', '01:45',
      '02:00', '02:15', '02:30', '02:45',
      '03:00', '03:15', '03:30', '03:45',
      '04:00', '04:15', '04:30', '04:45',
      '05:00', '05:15', '05:30', '05:45',
      '06:00', '06:15', '06:30', '06:45',
      '07:00', '07:15', '07:30', '07:45',
      '08:00', '08:15', '08:30', '08:45',
      '09:00', '09:15', '09:30', '09:45',
      '10:00', '10:15', '10:30', '10:45',
      '11:00', '11:15', '11:30', '11:45',
      '12:00', '12:15', '12:30', '12:45',
      '13:00', '13:15', '13:30', '13:45',
      '14:00', '14:15', '14:30', '14:45',
      '15:00', '15:15', '15:30', '15:45',
      '16:00', '16:15', '16:30', '16:45',
      '17:00', '17:15', '17:30', '17:45',
      '18:00', '18:15', '18:30', '18:45',
      '19:00', '19:15', '19:30', '19:45',
      '20:00', '20:15', '20:30', '20:45',
      '21:00', '21:15', '21:30', '21:45',
      '22:00', '22:15', '22:30', '22:45',
      '23:00', '23:15', '23:30', '23:45'
    ]

    temp_static_date_list = %w[
      2023-12-25
      2023-12-26
      2023-12-27
      2023-12-28
      2023-12-29
    ]

    # this alone does not account for having the same service job assigned to 2 techs at the same
    # time. I dont beleive it would make a difference but this is a reminder

    temp_static_date_list.each do |date|
      User.only_technicians.each do |user|
        2.times do
          start_time_string = allowed_time_inputs.sample
          start_time = Time.parse(start_time_string)
          end_time = start_time + rand(1..4).hours

          available_service_jobs = ServiceJob.all.to_a - user.user_service_jobs.where(date:).pluck(:service_job_id)

          if available_service_jobs.empty?
            puts "no available service jobs for user_id: #{user.id}, date: #{date}"
            break
          end

          service_job = available_service_jobs.sample

          puts "checking: user_id: #{user.id}, service_job_id: #{service_job.id}, date: #{date}"

          UserServiceJob.create!(
            user_id: user.id,
            service_job_id: service_job.id,
            start_time:,
            end_time:,
            date:
          )

          puts "creating: user_id: #{user.id}, service_job_id: #{service_job.id}, date: #{date}"
        rescue ActiveRecord::RecordNotUnique
          retry
        end
      end
    end
  end
end
