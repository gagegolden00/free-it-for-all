class ScheduleController < ApplicationController
  layout 'application_full'
  include ScheduleHelper

  def index
    @current_date = Time.now
    @service_jobs = ServiceJob.kept.order(job_number: 'desc')
    @selected_date = params[:selected_date] || @current_date.strftime('%Y-%m-%d')
    @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(params[:selected_date].present? ? params[:selected_date] : @current_date)
    @technician_users = User.only_technicians
  end
end
