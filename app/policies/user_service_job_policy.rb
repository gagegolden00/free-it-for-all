class UserServiceJobPolicy < ApplicationPolicy
  attr_reader :user, :user_service_job

  def initialize(user, user_service_job)
    @user = user
    @service_job = user_service_job
  end

  def create?
    user.admin?
  end

  def destroy?
    user.admin?
  end

  def update?
    user.admin?
  end

end
