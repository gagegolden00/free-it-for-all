class TimeLogPolicy < ApplicationPolicy
  attr_reader :user, :service_report

  def initialize(user, service_report)
    @user = user
    @service_job = service_report
  end

  def new?
    user.admin? || user.technician?
  end

  def create?
    user.admin? || user.technician?
  end

  def index?
    user.admin?
  end

  def show?
    user.admin?
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

end
