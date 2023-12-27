namespace :populate_db do
  desc 'create specific data for technician user'
  task create_technician_user_data: :environment do

    def remove_technician_user_random_data
      tech = User.where(name: 'technician user').first
      tech.user_service_jobs.destroy_all
      tech.service_reports.destroy_all
      tech.time_logs.destroy_all
    end

    remove_technician_user_random_data

    10.times do |index|
      tech = User.where(name: 'technician user').first
      customer = Customer.find(rand(1..Customer.count))
      work_site = WorkSite.find(rand(1..WorkSite.count))
      material = Material.find(rand(1..Material.count))

      puts "tech user iteration #{index}"
      puts "tech id #{tech.id}"
      puts "customer id #{customer.id}"
      puts "work site id #{work_site.id}"
      puts "material id #{material.id}"

      service_job = ServiceJob.create!(
        job_number: "SER-0#{index}",
        status: ServiceJob.statuses.values.sample,
        description: Faker::Lorem.paragraph(sentence_count: rand(3..30)),
        work_type: Faker::Lorem.sentence(word_count: rand(1..20)),
        customer_id: customer.id,
        work_site_id: work_site.id,
        discarded_at: nil,
      )
      puts "Service job #{service_job.job_number}"

      user_service_job = UserServiceJob.create!(
        user_id: tech.id,
        service_job_id: service_job.id,
        date: Date.today + index.day,
        start_time: Time.parse("0#{rand(5..9)}:00"),
        end_time: Time.now + rand(1..8).hours
      )

      puts "user service job for #{user_service_job.service_job.job_number}"

      service_report = ServiceReport.create!(
        service_report_number: "REP-0#{index}",
        warranty: false,
        equipment_model: 'Equipment Model',
        equipment_serial: '12345',
        description: Faker::Lorem.paragraph(sentence_count: rand(3..30)),
        service_job_id: service_job.id,
        user_id: tech.id,
        time_log_attributes: {
            regular_minutes: 120,
            overtime_minutes: 30,
            double_time_minutes: 15,
            mileage: 50,
            remarks: 'Some remarks',
            user_id: tech.id
          }
      )

      ServiceReportMaterial.create!(
        service_report_id: service_report.id,
        material_id: material.id,
        quantity: 4,
        pre_tax_total: material.price * 4
      )

      PurchaseOrder.create!(
        purchase_order_number: "PO-0#{index}",
        vendor: 'Vendor Name',
        description: 'Purchase Order Description',
        quantity: 3,
        price: 3.14,
        total_price: 3 * 3.14,
        notes: Faker::Lorem.paragraph(sentence_count: rand(3..10)),
        internal_notes: Faker::Lorem.paragraph(sentence_count: rand(3..10)),
        service_report_id: service_report.id
      )

      index = index + 1
    end
  end
end
