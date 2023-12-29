class UserServiceJobsController < ApplicationController

  def create
    @user_service_job = UserServiceJob.new(user_service_job_params)
    authorize @user_service_job
    return unless @user_service_job.save!
    flash[:notice] = "User successfully assigned and a notification has been sent to the technician."
    redirect_to dynamic_redirect_after_user_service_job_creation_based_on_referer
  end

  def destroy
    @user_service_job = UserServiceJob.find(params[:id])
    authorize @user_service_job
    return unless @user_service_job.discard
    flash[:notice] = "User successfully unassigned and a notification has been sent to the technician."
    redirect_to dynamic_redirect_after_user_service_job_creation_based_on_referer
  end

  def update
    @user_service_job = UserServiceJob.find(params[:id])
    authorize @user_service_job
    return unless @user_service_job.update!(user_service_job_params)
    flash[:notice] = "Schedule successfully updated"
    redirect_to schedule_path
  end

  private

  def user_service_job_params
    params.require(:user_service_job).permit(:service_job_id, :user_id, :date, :start_time, :end_time)
  end

  def dynamic_redirect_after_user_service_job_creation_based_on_referer
    if request.referer.include?('schedule')
      schedule_path
    elsif request.referer.include?('service_job')
      service_job_path(params[:user_service_job][:service_job_id])
    else
      flash.clear
      flash[:notice] = "Something went wrong"
      root_path
    end
  end

  def notify_user_has_been_unassigned
    message = "You have been unasigned from #{@service_job.job_number}."
    @notification = UserAssignmentNotification.with(message: message)
    authorize @notification
    @notification.deliver_later(current_user)
  end

  def notify_uesr_has_been_assigned
    message = "You have been asigned to #{@service_job.job_number}. \n Log in or visit the link provided for details \n #{service_job_path(@service_job)}"
    @notification = UserAssignmentNotification.with(message: message)
    authorize @notification
    @notification.deliver_later(current_user)
  end
end
