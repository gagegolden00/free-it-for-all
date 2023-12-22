class ScheduleController < ApplicationController
  layout 'application_full'
  include ScheduleHelper

  def index
    # start with 1 user
    params[:selected_date] = '2023-12-25'
    @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(params[:selected_date])
  end
end


# [#<UserServiceJob:0x0000ffff8fdd2900
# start_time: 02:30
# end_time: 03:30

# #<UserServiceJob:0x0000ffff962c69b0
# start_time: 11:00
# end_time: 13:00
