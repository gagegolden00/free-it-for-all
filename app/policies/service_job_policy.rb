class ServiceJobPolicy < ApplicationPolicy
  attr_reader :user, :service_job

  def initialize(user, service_job)
    @user = user
    @service_job = service_job
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
    user.admin? || (
      user.technician? &&
      user.service_jobs.kept.include?(service_job) &&
      !user.user_service_jobs.find_by(service_job: service_job).discarded?
      )
  end

  def edit?
    user.admin?
  end

  def update?
    user.admin? || user.technician? 
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def initialize(user, scope)
      @user  = user
      @scope = scope
    end

    def resolve
      if user.admin?
        scope.kept
      else
        user.service_jobs.kept.joins(:user_service_jobs).where(user_service_jobs: {discarded_at: nil})
      end
    end
  end

end
