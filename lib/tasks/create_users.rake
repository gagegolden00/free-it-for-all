namespace :populate_database do
  desc 'Create user accounts'
  task create_users: :environment do
    # Create an admin user
    User.create!(
      role: 'admin',
      name: 'admin user',
      home_phone: '123-456-7899',
      work_phone: '098-765-4322',
      carrier: 'A cell carrier',
      address: '123 asdf street',
      city: 'shreveport',
      state: 'Louisiana',
      zipcode: 12_345,
      hire_date: '10/10/2020',
      email: 'admin@email.com',
      password: 'asdfasdf'
    )

    # Create a technician user
    User.create!(
      role: 'technician',
      name: 'technician user',
      home_phone: '123-456-7891',
      work_phone: '098-765-4325',
      carrier: 'A cell carrier',
      address: '456 fdsa street',
      city: 'shreveport',
      state: 'Louisiana',
      zipcode: 54_344,
      hire_date: '10/10/2020',
      email: 'technician@email.com',
      password: 'asdfasdf'
    )

    # Create 10 random admin users
    10.times do
      name = Faker::Name.name
      User.create!(
        role: 'admin',
        name:,
        home_phone: Faker::PhoneNumber.phone_number,
        work_phone: Faker::PhoneNumber.phone_number,
        carrier: Faker::Name.name,
        address: Faker::Address.street_name,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip_code.to_i,
        hire_date: Faker::Date.between(from: '2010-01-01', to: '2023-01-01'),
        email: "#{name.downcase.gsub(' ', '_').gsub('.', '')}@email.com",
        password: 'asdfasdf'
      )
    end

    # Create 10 random technician users
    10.times do
      name = Faker::Name.name
      User.create!(
        role: 'technician',
        name:,
        home_phone: Faker::PhoneNumber.phone_number,
        work_phone: Faker::PhoneNumber.phone_number,
        carrier: Faker::Name.name,
        address: Faker::Address.street_name,
        city: Faker::Address.city,
        state: Faker::Address.state,
        zipcode: Faker::Address.zip_code.to_i,
        hire_date: Faker::Date.between(from: '2010-01-01', to: '2023-01-01'),
        email: "#{name.downcase.gsub(' ', '_').gsub('.', '')}@email.com",
        password: 'asdfasdf'
      )
    end
  end
end
