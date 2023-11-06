namespace :populate_db do
  desc 'Runs all of the rake tasks needed to generate data in the correct order'
  task generate_all_data: :environment do

      rakes = {
        create_users: 'rake populate_db:create_users',
        create_customers: 'rake populate_db:create_customers',
        create_service_jobs: 'rake populate_db:create_service_jobs',
        create_service_reports: 'rake populate_db:create_service_reports',
        create_materials: 'rake populate_db:create_materials',
        create_service_report_materials: 'rake populate_db:create_service_report_materials',
        create_user_service_jobs: 'rake populate_db:create_user_service_jobs',
        create_purchase_orders: 'rake populate_db:create_purchase_orders'
      }

      rakes.each do |key, value|
        puts "Task: " + key.to_s
        system(value)
      end

  end
end
