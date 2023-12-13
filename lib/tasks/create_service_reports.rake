namespace :populate_db do
  desc 'Create service reports for service jobs'
  task create_service_reports: :environment do

    def random_minutes
      max_minutes = 60 * 24

      reg_time = max_minutes - rand(0..max_minutes)
      minutes_left = max_minutes - reg_time

      if minutes_left <= 0
        over_time = 0
        double_time = 0
        return [reg_time, over_time, double_time]
      end
      over_time = minutes_left - rand(0..minutes_left)
      final_minutes = over_time - minutes_left - over_time

      if final_minutes <= 0
        double_time = 0
        return [reg_time, over_time, double_time]
      end
      double_time = final_minutes - rand(0..final_minutes)

      [reg_time, over_time, double_time]
    end

    600.times do
      reg_time, double_time, over_time = random_minutes

      user_service_job = UserServiceJob.find(rand(1..UserServiceJob.count))
      service_job = ServiceJob.find(user_service_job.service_job_id)
      assigned_user_id = user_service_job.user_id

      puts "######################"

      puts assigned_user_id.class
      puts assigned_user_id

      #puts User.find(assigned_user_id).name.upcase

      puts "######################"

      ServiceReport.create!(
        service_report_number: service_job.job_number + "-REPORT-#{service_job.service_reports.count + 1}",
        warranty: Faker::Boolean.boolean,
        equipment_model: Faker::Device.model_name,
        equipment_serial: Faker::Device.serial,
        mischarge: rand(1...1_000_000_000),
        total_charge: rand(1..1_000_000_000),
        description: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        employee_signature: Faker::Name.name,
        customer_signature: Faker::Name.name,
        service_job_id: service_job.id,
        user_id: assigned_user_id,
        time_log_attributes: {
          regular_minutes: rand(240..480),
          overtime_minutes: rand(240..480),
          double_time_minutes: rand(240..480),
          mileage: rand(1..100_000),
          remarks: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
          user_id: assigned_user_id
        }
      )
    end

    def update_timestamps
      start_date = Time.new(2023, 1, 1, 9, 0, 0)
      end_date = Time.new(2023, 12, 31, 21, 0, 0)
      number_of_reports = ServiceReport.count
      timestamps = (start_date..end_date).step((end_date - start_date) / number_of_reports).to_a

      ServiceReport.all.each do |service_report|
        timestamp = timestamps.shift
        service_report.created_at = timestamp
        service_report.time_log.created_at = timestamp

      end
    end

    update_timestamps

  end
end
