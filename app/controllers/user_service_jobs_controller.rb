class UserServiceJobsController < ApplicationController

  def create
    @existing_record = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:service_job_id])
    @user_service_job = UserServiceJob.new(user_service_job_params)
    @service_job = ServiceJob.find(params[:service_job_id])

    authorize @user_service_job

    if @existing_record && !@existing_record.discarded?
      flash[:notice] = "Technician is already assigned"
      redirect_to dynamic_redirect_after_user_service_job_creation_based_on_referer

    elsif @existing_record
      flash[:notice] = "Technician has been re-assigned"
      @existing_record.undiscard!
      redirect_to dynamic_redirect_after_user_service_job_creation_based_on_referer
      notify_uesr_has_been_assigned

    elsif @user_service_job.save
      flash[:notice] = "Technician has been assigned"
      redirect_to dynamic_redirect_after_user_service_job_creation_based_on_referer
      notify_uesr_has_been_assigned

    else
      flash[:notice] = "Technician could not be assigned"
      redirect_to dynamic_redirect_after_user_service_job_creation_based_on_referer
    end
  end

  def destroy
    if params[:user_id].present? && params[:service_job_id].present?
      unassign_user_from_service_job_show_path
    elsif params[:id] && params[:service_job_id].present?
      unassign_user_from_schedule_path
    end
  end

  def update
    @user_service_job = UserServiceJob.find(params[:id])
    authorize @user_service_job
    if @user_service_job.update!(update_user_service_job_params)
      flash[:notice] = "Schedule successfully updated"
      redirect_to schedule_path
    end
  end

  private

  def user_service_job_params
    params.permit(:service_job_id, :user_id, :date, :start_time, :end_time)
  end

  def update_user_service_job_params
    params.require(:user_service_job).permit(:date, :start_time, :end_time)
  end

  def dynamic_redirect_after_user_service_job_creation_based_on_referer
    if request.referer.include?('schedule')
      schedule_path
    elsif request.referer.include?('service_job')
      service_job_path(params[:service_job_id])
    else
      flash.clear
      flash[:notice] = "Something went wrong"
      '/'
    end
  end

  def unassign_user_from_service_job_show_path
    @user_service_job = UserServiceJob.find_by(user_id: params[:user_id], service_job_id: params[:id])
    @service_job = ServiceJob.find(params[:service_job_id]) if params[:service_job_id].present?
    authorize @user_service_job

    return unless @user_service_job.discard
    flash[:notice] = "Technician has been unassigned"
    redirect_to service_job_path(params[:service_job_id])
    notify_user_has_been_unassigned
  end

  def unassign_user_from_schedule_path
    @user_service_job = UserServiceJob.find(params[:id])
    @service_job = ServiceJob.find(params[:service_job_id]) if params[:service_job_id].present?
    authorize @user_service_job

    return unless @user_service_job.discard
    flash[:notice] = "Technician has been unassigned"
    redirect_to schedule_path
    notify_user_has_been_unassigned
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
