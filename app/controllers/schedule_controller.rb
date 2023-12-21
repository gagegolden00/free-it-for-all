class ScheduleController < ApplicationController
  layout 'application_full'
  include ScheduleHelper

  def index
    # start with 1 user
    params[:selected_date] = '2023-12-27'
    @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(params[:selected_date])
    binding.pry
  end
end
