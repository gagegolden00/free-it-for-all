namespace :populate_db do
  desc 'Creates regions.'
  task create_regions: :environment do

    Region.create!(
      name: 'North America',
      manager: Faker::Name.name
    )
    Region.create!(
      name: 'South America',
      manager: Faker::Name.name
    )
  end
end
