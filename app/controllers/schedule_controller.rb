class ScheduleController < ApplicationController
  layout 'application_full'
  include ScheduleHelper

  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @current_date = Time.now
    @service_jobs = ServiceJob.kept.order(job_number: 'desc')
    @selected_date = if params[:service_job] && params[:service_job][:date].present?
                       params[:service_job][:date]
                     elsif params[:selected_date].present?
                       params[:selected_date]
                     else
                       @current_date.strftime('%Y-%m-%d')
                     end
    @technician_users = User.only_technicians
    @user_service_job_errors = session[:user_service_job_errors] if session[:user_service_job_errors].present?
    @user_serivce_job_errors.nil? || @user_service_job_errors.empty ? session.delete(:user_service_job_errors) : nil

    @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(params[:selected_date].present? ? params[:selected_date] : @current_date)
    authorize :schedule, :index?

    if params[:display_modal].present? && params[:display_modal] == 'true'
      display_service_job_details
    elsif params[:display_modal].present? && params[:display_modal] == 'false'
      hide_service_job_detials
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
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('scheduleDetials', partial: 'schedule_detials',
                                                                     locals: { service_job: @service_job })
      end
    end
  end

  def hide_service_job_detials
    respond_to do |format|
      format.html
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace('scheduleDetailsModal', partial: 'blank_partial')
      end
    end
  end
end
