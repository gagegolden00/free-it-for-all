class TimeSheetPolicy < ApplicationPolicy

  def initialize(user, time_logs)
    @user = user
    @time_logs = time_logs
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

end
