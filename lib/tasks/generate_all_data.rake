namespace :populate_db do
  desc 'Runs all of the rake tasks needed to generate data in the correct order'
  task generate_all_data: :environment do

      rakes = {
        create_users: 'rake populate_database:create_users',
        create_customers: 'rake populate_database:create_customers',
        create_service_jobs: 'rake populate_database:create_service_jobs'
      }

      rakes.each do |key, value|
        puts "Task: " + key.to_s
        system(value)
      end

  end
end
