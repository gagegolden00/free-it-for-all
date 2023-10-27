namespace :populate_db do
  desc "Create service reports for service jobs"
  task create_service_reports: :environment do

    100.times do
      ServiceReport.create!(
        service_report_number: Faker::Alphanumeric.alpha(number: 10),
        warranty: Faker::Boolean.boolean,
        equipment_model: Faker::Device.model_name,
        equipment_serial: Faker::Device.serial,
        mischarge: rand(1...1_000_000_000),
        total_charge: rand(1..1_000_000_000),
        description: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        employee_signature: Faker::Name.name,
        customer_signature: Faker::Name.name,
        service_job_id: rand(1..ServiceJob.count)
      )
    end
  end
end
