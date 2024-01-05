class ServiceJobPersistanceService < ApplicationService
  def initialize(params, permitted_params, service_job)
    @params = params
    @permitted_params = permitted_params
    @service_job = service_job
  end

  def call
    if !any_child_record_errors? && @service_job.save
      OpenStruct.new(success?: true, payload: @service_job)
    else
      OpenStruct.new(success?: false, payload: service_job_with_child_record_errors)
    end
  end

  private

  def any_child_record_errors?
    get_customer_errors if @params.dig(:service_job, :customer_attributes).present?
    get_point_of_contact_errors if @params.dig(:service_job, :customer_attributes, :point_of_contact_attributes).present?
    get_work_site_errors if @params.dig(:service_job, :work_site_attributes).present?
  end

  def service_job_with_child_record_errors
    @service_job.errors.clear

    customer_errors = prepend_class_name(@customer&.errors&.full_messages, 'Customer')
    point_of_contact_errors = prepend_class_name(@point_of_contact&.errors&.full_messages, 'PointOfContact')
    work_site_errors = prepend_class_name(@work_site&.errors&.full_messages, 'WorkSite')

    @service_job.errors.add(:customer, customer_errors) if customer_errors.present?
    @service_job.errors.add(:point_of_contact, point_of_contact_errors) if point_of_contact_errors.present?
    @service_job.errors.add(:work_site, work_site_errors) if work_site_errors.present?

    OpenStruct.new(success?: false, payload: @service_job.errors.messages)
  end

  def prepend_class_name(errors, class_name)
    errors&.map do |error|
      error.start_with?(class_name) ? error : "#{class_name}: #{error}"
    end
  end

  def get_customer_errors
    @customer = Customer.new(@permitted_params.dig(:customer_attributes))
    return false if @customer.valid?
    build_child_records
    @customer
  end

  def get_point_of_contact_errors
    @point_of_contact = PointOfContact.new(@permitted_params.dig(:point_of_contact_attributes))
    return false if @point_of_contact.valid?
    build_child_records
    @point_of_contact
  end

  def get_work_site_errors
    @work_site = WorkSite.new(@permitted_params.dig(:work_site_attributes))
    return false if @work_site.valid?
    build_child_records
    @work_site
  end

  def build_child_records
    @service_job.build_customer
    @service_job.customer.build_point_of_contact
    @service_job.build_work_site
  end
end
