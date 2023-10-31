class ServiceReportTimeConverterService < ApplicationService
  def initialize(params: )
    @params = params
  end

  def call

    reg_hours = params[:time_log_attributes][:reg_hours]
    reg_minutes = params[:time_log_attributes][:reg_minutes]

    over_hours = params[:time_log_attributes][:over_hours]
    over_minutes = params[:time_log_attributes][:over_minutes]

    double_hours = params[:time_log_attributes][:double_minutes]
    double_minutes = params[:time_log_attributes][:double_minutes]

    

  end

end
