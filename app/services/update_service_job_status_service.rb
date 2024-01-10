class UpdateServiceJobStatusService < ApplicationService

  def initialize(service_job, params)
    @service_job = service_job
    @params = params
  end


  def call
    @service_job.status = @params[:status]
    @service_job.save!
  end


end
