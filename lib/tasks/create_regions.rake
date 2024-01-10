namespace :populate_db do
  desc 'Creates regions.'
  task create_regions: :environment do

    Region.create!(
      name: 'North',
      manager: Faker::Name.name
    )
    Region.create!(
      name: 'South',
      manager: Faker::Name.name
    )
  end
end
