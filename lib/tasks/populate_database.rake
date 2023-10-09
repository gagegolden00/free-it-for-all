
namespace :populate_database do
  desc "Create user accounts"
  task :create_users => :environment do
    # Create an admin user
    User.create!(
      role: "admin",
      name: "admin user",
      home_phone: "123-456-7899",
      work_phone: "098-765-4322",
      carrier: "A cell carrier",
      hire_date: "10/10/2020",
      email: "admin@email.com",
      password: "asdfasdf"
    )

    # Create a technician user
    User.create!(
      role: "technician",
      name: "technician user",
      home_phone: "123-456-7891",
      work_phone: "098-765-4325",
      carrier: "A cell carrier",
      hire_date: "10/10/2020",
      email: "technician@email.com",
      password: "asdfasdf"
    )

    # Create 10 random admin users
    10.times do
      name = Faker::Name.name
      User.create!(
        role: "admin",
        name: name,
        home_phone: Faker::PhoneNumber.phone_number,
        work_phone: Faker::PhoneNumber.phone_number,
        carrier: Faker::Name.name,
        hire_date: Faker::Date.between(from: '2010-01-01', to: '2023-01-01'),
        email: "#{name.downcase.gsub(' ', '_')}@email.com",
        password: "asdfasdf"
      )
    end

    # Create 10 random technician users
    10.times do
      name = Faker::Name.name
      User.create!(
        role: "technician",
        name: name,
        home_phone: Faker::PhoneNumber.phone_number,
        work_phone: Faker::PhoneNumber.phone_number,
        carrier: Faker::Name.name,
        hire_date: Faker::Date.between(from: '2010-01-01', to: '2023-01-01'),
        email: "#{name.downcase.gsub(' ', '_')}@email.com",
        password: "asdfasdf"
      )
    end
  end
end
