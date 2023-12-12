class UserServiceJobsController < ApplicationController

  def create
    @existing_record = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:service_job_id])
    @user_service_job = UserServiceJob.new(user_service_job_params)

    authorize @user_service_job

    if @existing_record && !@existing_record.discarded?
      flash[:notice] = "Technician is already assigned"
      redirect_to service_job_path(params[:service_job_id])

    elsif @existing_record
      flash[:notice] = "Technician has been re-assigned"
      @existing_record.undiscard!
      redirect_to service_job_path(params[:service_job_id])
      sms_notify_tech_has_been_assigned # Add user attributes to calls after twilio setup

    elsif @user_service_job.save
      flash[:notice] = "Technician has been assigned"
      redirect_to service_job_path(params[:service_job_id])
      sms_notify_tech_has_been_assigned # Add user attributes to calls after twilio setup

    else
      flash[:notice] = "Technician could not be assigned"
      redirect_to service_job_path(params[:service_job_id])
    end
  end

  def destroy
    @user_service_job = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:id])
    authorize @user_service_job

    return unless @user_service_job.discard
    flash[:notice] = "Technician has been unassigned"
    redirect_to service_job_path(params[:service_job_id])
  end

  private

  def user_service_job_params
    params.permit(:service_job_id, :user_id, :date, :start_time, :end_time)
  end

  def sms_notify_tech_has_been_assigned
    @user = User.find(params[:user_id])
    @service_job = ServiceJob.find(params[:service_job_id])
    
    techs_number = '+18777804236'
    message = "Tech has been assigned"
    notification = SmsNotification.with(service_job: @service_job)
    notification.deliver(techs_number)
  end


end
