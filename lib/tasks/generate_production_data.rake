namespace :populate_db do
  desc 'Runs all of the rake tasks needed to generate production data.'
  task generate_production_data: :environment do
      rakes = {
        create_production_users: 'rake populate_db:create_production_users',
        create_materials: 'rake populate_db:create_materials',
        create_regions: 'rake populate_db:create_regions'
      }

      rakes.each do |key, value|
        puts "Task: " + key.to_s
        system(value)
      end

  end
end
