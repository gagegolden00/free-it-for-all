namespace :populate_db do
  desc 'create purchase orders'
  task create_purchase_orders: :environment do

    1000.times do
      service_report = ServiceReport.find(rand(1..ServiceReport.count))
      service_job = ServiceJob.find(service_report.service_job_id)
      PurchaseOrder.create!(
        purchase_order_number: service_job.job_number + "-PO-#{service_report.purchase_orders.count + 1}",
        quantity: Faker::Number.between(from: 1, to: 100),
        vendor: Faker::Name.name,
        description: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        price: Faker::Number.decimal(l_digits: 2),
        total_price: Faker::Number.decimal(l_digits: 2),
        notes: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        internal_notes: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        service_report_id: service_report.id
      )
    end

  end
end

