namespace :populate_database do
  desc 'create customers entries'
  task create_customers: :environment do
    counter = 1
    Region.create!(
      name: 'North America',
      manager: Faker::Name.name
    )
    Region.create!(
      name: 'South America',
      manager: Faker::Name.name
    )

    100.times do
      name1 = Faker::Name.name
      name2 = Faker::Name.name
      Customer.create!(
        name: name1,
        phone_number: Faker::PhoneNumber.phone_number,
        email: "#{name1.downcase.gsub(' ', '_').gsub('.', '')}@email.com",
        address: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip,
        region_id: counter,
        point_of_contact_attributes: {
          name: name2,
          phone_number: Faker::PhoneNumber.phone_number,
          email: "#{name2.downcase.gsub(' ', '_').gsub('.', '')}@email.com"
        }
      )
      counter = counter == 1 ? 2 : 1
    end
  end
end
