class ScheduleController < ApplicationController
    layout 'application_full'

    def index
    # start with 1 user

    @user_service_job = UserServiceJob.joins(:users).first

    

    end

end
