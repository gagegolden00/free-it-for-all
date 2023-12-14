class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def index?
    user.admin?
  end

  def show?
    user.admin? || (user.technician? && record == user)
  end

  def edit?
    user.admin? || (user.technician? && record == user)
  end

  def update?
    edit?
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
