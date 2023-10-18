
class Admin::ServiceJobsController < Admin::ApplicationController
  before_action :set_service_job_from_params, only: %i[show edit update delete]

  def new
    @service_job = ServiceJob.new
  end

  def create
    service_job = ServiceJobCreateService.new(params)
    if service_job.save?
      redirect_to service_job
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
    @service_job = service_job_params[:id]
  end
end



