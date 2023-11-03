namespace :populate_db do
  desc 'create purchase orders'
  task create_purchase_orders: :environment do

    5000.times do
      PurchaseOrder.create!(
        purchase_order_number: Faker::Alphanumeric.alpha(number: 10),
        quantity: Faker::Number.between(from: 1, to: 100),
        description: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        price: Faker::Number.decimal(l_digits: 2),
        total_price: Faker::Number.decimal(l_digits: 2),
        notes: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        internal_notes: Faker::Lorem.paragraph(sentence_count: rand(1..20)),
        service_report_id: rand(1..ServiceReport.count)
      )
    end
    
  end
end

