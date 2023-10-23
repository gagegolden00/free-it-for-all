class Admin::UserServiceJobsController < ApplicationController

  def create
    @user_service_job = UserServiceJob.new(user_service_job_params)
    if @user_service_job.save
      flash[:notice] = "Technician has been assigned"
      redirect_to admin_service_job_path(params[:service_job_id])
    else
      render @service_job
    end
  end

  def destroy
    @user_service_job = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:id])
    if @user_service_job.discard
      flash[:notice] = "Technician has been unassigned"
      redirect_to admin_service_job_path(params[:id])
    else
      render @service_job
    end
  end

  private

  def user_service_job_params
    params.permit(:service_job_id, :user_id)
  end


end
