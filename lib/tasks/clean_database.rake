namespace :populate_db do
  desc 'Refresh the database, this will remove all data'
  task clean_database: :environment do

    rails_commands = {
      db_drop: 'rails db:drop',
      db_create: 'rails db:create',
      db_schema_dump: 'rails db:schema:dump',
      db_migrate: 'rails db:migrate'
    }

    rails_commands.each do |key, value|
      puts 'Command: ' + key.to_s
      system(value)
    end

  end
end
