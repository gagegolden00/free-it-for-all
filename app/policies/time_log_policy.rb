class TimeLogPolicy < ApplicationPolicy
  def initialize(user, time_logs)
    @user  = user
    @time_logs = time_logs
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || user.technician?
  end

  class Scope < Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      user.time_logs.where(created_at: @start_date..@end_date)
    end

    def resolve
      return scope.all if user.admin?
      return scope.where(user: user) if user.technician?
    end
  end
end
