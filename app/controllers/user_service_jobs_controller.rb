class UserServiceJobsController < ApplicationController

  def create
    @existing_record = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:service_job_id])
    @user_service_job = UserServiceJob.new(user_service_job_params)
    @service_job = ServiceJob.find(params[:service_job_id])

    authorize @user_service_job

    if @existing_record && !@existing_record.discarded?
      flash[:notice] = "Technician is already assigned"
      redirect_to service_job_path(params[:service_job_id])

    elsif @existing_record
      flash[:notice] = "Technician has been re-assigned"
      @existing_record.undiscard!
      redirect_to service_job_path(params[:service_job_id])
      message = "You have been asigned to #{@service_job.job_number}. \n Log in or visit the link provided for details \n #{service_job_path(@service_job)}"
      UserAssignmentNotification.with(message: message).deliver(current_user)

    elsif @user_service_job.save
      flash[:notice] = "Technician has been assigned"
      redirect_to service_job_path(params[:service_job_id])
      message = "You have been asigned to #{@service_job.job_number}. \n Log in or visit the link provided for details \n #{service_job_path(@service_job)}"
      UserAssignmentNotification.with(message: message).deliver(current_user)

    else
      flash[:notice] = "Technician could not be assigned"
      redirect_to service_job_path(params[:service_job_id])
    end
  end

  def destroy
    @user_service_job = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:id])
    @service_job = ServiceJob.find(params[:service_job_id])
    authorize @user_service_job
    return unless @user_service_job.discard
    flash[:notice] = "Technician has been unassigned"
    redirect_to service_job_path(params[:service_job_id])
    message = "You have been unasigned from #{@service_job.job_number}."
    UserAssignmentNotification.with(message: message).deliver(current_user)
  end

  private

  def user_service_job_params
    params.permit(:service_job_id, :user_id, :date, :start_time, :end_time)
  end

end
