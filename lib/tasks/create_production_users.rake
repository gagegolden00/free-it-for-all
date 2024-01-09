namespace :populate_db do
  desc 'Creates users with client logins'
  task create_production_users: :environment do
    # Create an admin user
    User.create!(
      role: 'admin',
      name: 'Mechcool admin',
      home_phone: '123-456-7899',
      work_phone: '098-765-4322',
      carrier: 'A cell carrier',
      address: '123 asdf street',
      city: 'shreveport',
      state: 'Louisiana',
      zip_code: 12_345,
      hire_date: '10/10/2020',
      email: 'admin@mechcool.com',
      password: 'mechcool'
    )

    counter = 1
    10.times do
      User.create!(
        role: 'technician',
        name: "Mechcool tech #{counter}",
        home_phone: '123-456-7891',
        work_phone: '098-765-4325',
        carrier: 'A cell carrier',
        address: '456 fdsa street',
        city: 'shreveport',
        state: 'Louisiana',
        zip_code: 54_344,
        hire_date: '10/10/2020',
        email: "technician_#{counter}@mechcool.com",
        password: 'mechcool'
      )

      counter += 1
    end
  end
end
