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

    400.times do
      reg_time, double_time, over_time = random_minutes

      user_service_job = UserServiceJob.find(rand(1..UserServiceJob.count))
      service_job = ServiceJob.find(user_service_job.service_job_id)
      assigned_user_id = user_service_job.user_id

      ServiceReport.create!(
        service_report_number: service_job.job_number + "-REPORT-#{service_job.service_reports.count + 1}",
        warranty: Faker::Boolean.boolean,
        equipment_model: Faker::Device.model_name,
        equipment_serial: Faker::Device.serial,
        mischarge: rand(1...1_000_000_000),
        total_charge: rand(1..1_000_000_000),
        description: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        employee_signature: nil,
        customer_signature: nil,
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
  end
end
