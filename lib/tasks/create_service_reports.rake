namespace :populate_db do
  desc 'Create service reports for service jobs'
  task create_service_reports: :environment do

    def random_minutes
      max_minutes = 60 * 24

      reg = max_minutes - rand(0..max_minutes)
      minutes_left = max_minutes - reg

      if minutes_left <= 0
        over = 0
        double = 0
        return [reg, over, double]
      end
      over = minutes_left - rand(0..minutes_left)
      final_minutes = over - minutes_left - over

      if final_minutes <= 0
        double = 0
        return [reg, over, double]
      end
      double = final_minutes - rand(0..final_minutes)

      [reg, over, double]
    end

    100.times do
      reg, double, over = random_minutes
      service_job = ServiceJob.find(1..ServiceJob.count)

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
        time_log_attributes: {
          regular_minutes: reg,
          overtime_minutes: double,
          double_time_minutes: over,
          mileage: rand(1..100_000),
          remarks: Faker::Lorem.paragraph(sentence_count: rand(1..20))
        }
      )
    end

  end
end
