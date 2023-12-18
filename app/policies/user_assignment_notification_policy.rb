class UserAssignmentNotificationPolicy < ApplicationPolicy
  attr_reader :user, :notification

  def initialize(user, notification)
    @user = user
    @notification = notification
  end

  def create?
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
