class TimeSheetsController < ApplicationController
  layout 'application_full'
  include TimeLogHelper

  def index
    authorize :time_sheet


    @time_frame = params[:time_frame]

    case @time_frame
      when "Current week"
        set_current_week

      when "Last week"
        set_last_week

      when 'Custom time'
        if params[:start_date].nil? || params[:end_date].nil? || params[:start_date].empty? || params[:end_date].empty?
          flash[:alert] = "Oops! Please enter start date before end date!."
          redirect_to time_sheets_path
          return
        end
        set_custom_week

      else
        set_current_week
    end

    @users_with_time_log_totals = User.all_with_time_log_totals_in_time_period(@start_date, @end_date).order(get_sorting_order)
    @users_with_no_time_log_totals = User.all_with_no_time_logs_in_time_period(@start_date, @end_date).order(get_sorting_order)




  end


  def show

    if params[:start_date].present? && params[:end_date].present?
    @start_date = params[:start_date]
    @start_date = Time.zone.parse(@start_date.to_s).beginning_of_day

    @end_date = params[:end_date]
    @end_date = Time.zone.parse(@end_date.to_s).end_of_day

    else
      set_current_week
    end

    @user = User.find(params[:user_id])
    @time_logs = policy_scope(@user.time_logs).where(created_at: @start_date..@end_date)
    authorize @time_logs

  end


  private

  def get_sorting_order
    case params[:sort_by]
    when 'name asc'
      'name asc'
    when 'name desc'
      'name desc'
    else
      'name asc'
    end
  end

  def set_current_week
    set_week(Time.zone.now.beginning_of_week, Time.zone.now.end_of_week)
  end

  def set_last_week
    set_week(1.week.ago.beginning_of_week, 1.week.ago.end_of_week)
  end

  def set_custom_week
    set_week(Time.zone.parse(params[:start_date]).beginning_of_day, Time.zone.parse(params[:end_date]).end_of_day)
  end

  def set_week(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

end
