namespace :populate_database do
  desc "create customers entries"
  task :create_customers => :environment do
    region_id = 1


      Region.create!(
        name: "North Louisiana",
        manager: Faker::Name.name
      )
      Region.create!(
        name: "South Louisiana",
        manager: Faker::Name.name
      )

    100.times do
      customer = Customer.create!(
        name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.phone_number,
        email: Faker::Internet.email,
        address: Faker::Address.street_address,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip,
        customer_regions_attributes: [
          {
            region_id: region_id
          }
        ],
        point_of_contact_attributes: {
          name: Faker::Name.name,
          phone_number: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email
        }
      )
      region_id = (region_id == 1) ? 2 : 1
    end
  end
end
