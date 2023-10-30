class UserServiceJobPolicy < ApplicationPolicy
  attr_reader :user, :user_service_job

  def initialize(user, user_service_job)
    @user = user
    @service_job = user_service_job
  end

  def create
    user.admin?
  end

  def destroy
    user.admin?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
