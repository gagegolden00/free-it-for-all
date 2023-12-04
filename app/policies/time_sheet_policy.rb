class TimeSheetPolicy < ApplicationPolicy
  attr_reader :user, :time_logs

  def initialize(user, time_logs)
    @user = user
    @time_logs = time_logs
  end

  def index?
    user.admin?
  end
end
