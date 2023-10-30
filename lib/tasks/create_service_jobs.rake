namespace :populate_db do
  desc 'Create service job test data '
  task create_service_jobs: :environment do
    @random_counter = 1
    @nil_counter = 1

    def decide_params(random_counter, nil_counter)
      service_job_params = {
        job_number: 'SER' + rand(10_000..999_999).to_s,
        status: ServiceJob.statuses.values.sample,
        description: Faker::Lorem.paragraph(sentence_count: rand(3..30)),
        contract_amount: rand(1.00..1_000_000.00),
        work_type: Faker::Lorem.sentence(word_count: rand(1..20)),
        customer_id: rand(1..Customer.count),
        work_site_id: nil_counter.even? ? rand(1..WorkSite.count) : nil
      }

      customer_params = {
        customer_attributes: {
          name: Faker::Name.name,
          phone_number: Faker::PhoneNumber.phone_number,
          email: Faker::Internet.email,
          address: Faker::Address.street_address,
          city: Faker::Address.city,
          state: Faker::Address.state,
          zip_code: Faker::Address.zip
        }
      }

      worksite_params = {
        work_site_attributes: {
          name: Faker::Name.name,
          address: Faker::Address.street_address,
          city: Faker::Address.city,
          state: Faker::Address.state,
          zip_code: Faker::Address.zip,
          email: Faker::Internet.email,
          phone_number: Faker::PhoneNumber.phone_number
        }
      }

      point_of_contact_params = {
        name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.phone_number,
        email: Faker::Internet.email
      }

      # When creating with an existing customer the only option is to edit/create the point of contact from the customers show page
      # possibilities are as follows:
      case random_counter
      when 1
        # New service job, existing customer, no work site
        service_job_params
      when 2
        # New service job, existing customer, new work site
        service_job_params.except(:work_site_id).merge(worksite_params)
      when 3
        # New service job, new customer, no point of contact, no work site
        service_job_params.except(:customer_id).merge(customer_params)
      when 4
        # New service job, new customer, no point of contact, new work site
        service_job_params.except(:customer_id, :work_site_id).merge(customer_params, worksite_params)
      when 5
        # New service job, new customer, new point of contact, no work site
        service_job_params.except(:customer_id).merge(customer_params.merge(point_of_contact_params))
      when 6
        # New service job, new customer, new point of contact, new work site
        service_job_params.except(:customer_id).merge(customer_params.merge(point_of_contact_params), worksite_params)
      end
    end

    # The first 6 service jobs created can verify the expected results from the case statment
    # I did this so it was easy to grab them by thier id's
    6.times do
      params = decide_params(@random_counter, @nil_counter)
      ServiceJob.create!(params)
      @random_counter = @random_counter >= 4 ? 1 : @random_counter + 1
      @nil_counter = @nil_counter >= 4 ? 1 : @nil_counter + 1
    end

    # Tested 10,000 with no errors
    50.times do
      params = decide_params(@random_counter, @nil_counter)
      job_number = params[:job_number]

      unless ServiceJob.exists?(job_number: job_number)
        ServiceJob.create!(params)
      end

      @random_counter = @random_counter >= 4 ? 1 : @random_counter + 1
      @nil_counter = @nil_counter >= 4 ? 1 : @nil_counter + 1
    end

  end
end
