
class Admin::ServiceJobsController < Admin::ApplicationController
  include StateListHelper
  include StatusListHelper

  before_action :set_service_job_from_params, only: %i[show edit update delete]

  def new
    @customers = Customer.all
    @service_job = ServiceJob.new
    @service_job.build_customer
    @service_job.customer.build_point_of_contact
    @service_job.build_work_site
  end

  def create
    @customers = Customer.all
    service_job_service = CreateServiceJobService.new(params: params)
    @service_job = service_job_service.create

    if @service_job.save
      flash[:notice] = "Service job created"
      redirect_to admin_service_job_path(@service_job)
    else
      render :new
    end
  end



  def index
    @pagy, @service_jobs = pagy(ServiceJob.all)
  end

  def show;end

  def edit
  end

  def update
  end

  def destroy
    if @service_job.discard?
      redirect_to service_jobs_path
    end
  end

  private

  def set_service_job_from_params
    @service_job = ServiceJob.find(params[:id])
  end

end



