class ServiceReportTimeConverterService < ApplicationService
  FIELDS_TO_REMOVE = %w(regular_hours_input regular_minutes_input overtime_hours_input overtime_minutes_input double_time_hours_input double_time_minutes_input).freeze

  def initialize(params)
    @params = params
  end

  def call
    regular_hours = @params[:regular_hours_input].to_i
    regular_minutes = @params[:regular_minutes_input].to_i

    overtime_hours = @params[:overtime_hours_input].to_i
    overtime_minutes = @params[:overtime_minutes_input].to_i

    double_hours = @params[:double_time_hours_input].to_i
    double_minutes = @params[:double_time_minutes_input].to_i

    time_log_attributes = @params[:time_log_attributes]
    time_log_attributes[:regular_minutes] = ((regular_hours * 60) + regular_minutes).to_s
    time_log_attributes[:overtime_minutes] = ((overtime_hours * 60) + overtime_minutes).to_s
    time_log_attributes[:double_time_minutes] = ((double_hours * 60) + double_minutes).to_s

    FIELDS_TO_REMOVE.each { |field| @params.delete(field) }

    @params
  end
  
end




