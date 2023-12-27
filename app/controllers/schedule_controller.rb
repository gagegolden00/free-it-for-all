class ScheduleController < ApplicationController
  layout 'application_full'
  include ScheduleHelper

  def index
    @current_date = Time.now
    @service_jobs = ServiceJob.kept.order(job_number: 'desc')
    @selected_date = params[:selected_date] || @current_date.strftime('%Y-%m-%d')
    @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(params[:selected_date].present? ? params[:selected_date] : @current_date)
    @technician_users = User.only_technicians

    if params[:display_modal].present? && params[:display_modal] == 'true'
      display_service_job_details
      return
    elsif params[:display_modal].present? && params[:display_modal] == 'false'
      hide_service_job_detials
      return
    end

  end

  private

  def display_service_job_details
    @user_service_job = UserServiceJob.find(params[:user_service_job_id])
    @user = User.find(@user_service_job.user_id)
    @service_job = ServiceJob.find(@user_service_job.service_job_id)
    @customer = @service_job.customer
    @work_site = @service_job.work_site
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace('scheduleDetials', partial: 'schedule_detials', locals: { service_job: @service_job }) }
    end
  end

  def hide_service_job_detials
    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace('defaultModal', partial: 'blank_partial') }
    end
  end

end
