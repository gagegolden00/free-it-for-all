class ScheduleController < ApplicationController
    layout 'application_full'
    include ScheduleHelper

    def index

        # start with 1 user
        params[:selected_date] = '2023-12-20'

        @daily_tech_schedule_data = User.daily_schedule_for_techs_by_date(params[:selected_date])

    end

end



# <div class="bg-blue-500 text-white p-1 rounded" style="grid-column-start: 2; grid-column-end: 50;">Caddo Magnet</div>
# <div class="bg-green-500 text-white p-1 rounded" style="grid-column-start: 40; grid-column-end: 98;">Bossier Middle School</div>
# <div>Darth Vader</div>
# <div class="bg-yellow-500 text-white p-1 rounded" style="grid-column-start: 2; grid-column-end: 50;">Texarkana Magnet</div>
# <div class="bg-purple-500 text-white p-1 rounded" style="grid-column-start: 50; grid-column-end: 98;">Texarkana Middle School</div>
