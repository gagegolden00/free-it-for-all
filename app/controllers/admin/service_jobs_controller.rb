class Admin::ServiceJobsController < Admin::ApplicationController
  layout 'application_full'
  
  include StateListHelper
  include StatusListHelper

  before_action :set_service_job_from_params, only: %i[show edit update destroy]
  before_action :set_all_customers, only: %i[new create edit update]

  def new
    @service_job = ServiceJob.new
    @service_job.build_customer
    @service_job.customer.build_point_of_contact
    @service_job.build_work_site
  end

  def create
    @customers = Customer.all
    @service_job = ServiceJob.new(permitted_params)
    puts @service_job.inspect
    if @service_job.save
      flash[:notice] = 'Service job created'
      redirect_to admin_service_job_path(@service_job)
    else
      render :new
    end
  end

  def index
    @pagy, @service_jobs = pagy(ServiceJob.all)
  end

  def edit
    @service_job.build_customer
    @service_job.customer.build_point_of_contact
    @service_job.build_work_site
  end

  def update
    if @service_job.update(permitted_params)
      redirect_to admin_service_job_path(@service_job)
    else
      render :edit
    end

  end

  def destroy
    return unless @service_job.discard
    flash[:notice] = "Service Job deleted"
    redirect_to admin_service_jobs_path
  end

  private

  def set_service_job_from_params
    @service_job = ServiceJob.find(params[:id])
  end

  def set_all_customers
    @customers = Customer.all
  end

  def permitted_params
    params.require(:service_job).permit(
      :job_number,
      :status,
      :description,
      :contract_amount,
      :work_type,
      :customer_id,
      customer_attributes: [
        :name,
        :phone_number,
        :email,
        :address,
        :city,
        :state,
        :zip_code,
        { point_of_contact_attributes: %i[
          name
          phone_number
          email]
        }
      ],
      work_site_attributes: %i[
        name
        address
        city
        state
        zip_code
        email
        phone_number
      ]
    )
  end
end
