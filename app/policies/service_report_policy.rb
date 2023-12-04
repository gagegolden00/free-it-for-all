class ServiceReportPolicy < ApplicationPolicy
  attr_reader :user, :service_report

  def initialize(user, service_report)
    @user = user
    @service_report = service_report
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
  end

  def index?
    user.admin? || user.technician?
  end

  def show?
    user.admin? || user.technician?
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
