class ScheduleController < ApplicationController
  layout 'application_full'
  include ScheduleHelper

  rescue_from ActionController::UnknownFormat, with: :rescue_unknown_request_format_exception

  def index
    params[:schedule_view_type] ||= '24_hour'
    @current_date = Time.now
    @user = User.find(params[:user_id]) if params[:user_id]
    @service_jobs = ServiceJob.kept.includes(:customer).order(job_number: 'desc')
    @technician_users = User.only_technicians

    @user_service_job_errors = session[:user_service_job_errors]
    session.delete(:user_service_job_errors) if @user_service_job_errors.present?

    @selected_date =
      if params[:service_job] && params[:service_job][:date].present?
        params[:service_job][:date]
      elsif params[:selected_date].present?
        params[:selected_date]
      elsif session[:selected_date].present?
        session[:selected_date]
      else
        @current_date.strftime('%Y-%m-%d')
      end

    @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(@selected_date)
    authorize :schedule, :index?

    return unless params[:display_modal].present? || params[:schedule_view_type].present?
    if params[:display_modal] == 'true'
      display_service_job_details
    elsif params[:display_modal] == 'false'
      hide_service_job_detials
    elsif params[:schedule_view_type].present?
      alternate_12_24_hour_views
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

    def alternate_12_24_hour_views
      schedule_view_type = params[:schedule_view_type] || '24_hour'
      respond_to do |format|
        format.html
        format.turbo_stream do
          if schedule_view_type == '12_hour'
            render turbo_stream: turbo_stream.replace('24HourView', partial: '12_hour_view')
          else
            render turbo_stream: turbo_stream.replace('12HourView', partial: '24_hour_view')
          end
        end
      end
    end

    def rescue_unknown_request_format_exception
      redirect_to schedule_path, notice: 'User successfully assigned, and a notification has been sent to the technician.'
    end


end
