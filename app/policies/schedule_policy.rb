class SchedulePolicy < ApplicationPolicy

  def initialize(user, daily_tech_schedule_data)
    @user = user
    @daily_tech_schedule_data = daily_tech_schedule_data
  end

  def index?
    user.admin? || user.technician?
  end

  class Scope < Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      return unless user.admin?
      scope.daily_schedule_for_techs_by_date(selected_date)
    end

    private

    def selected_date
      @selected_date ||= params[:selected_date].present? || @current_date
    end
  end

end
