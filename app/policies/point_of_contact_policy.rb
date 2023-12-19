class PointOfContactPolicy < ApplicationPolicy
  attr_reader :user, :point_of_contact

  def initialize(user, point_of_contact)
    @user = user
    @point_of_contact = point_of_contact
  end

  def new?
    user.admin?
  end

  def create?
    new?
  end

  def edit?
    user.admin?
  end

  def update?
    edit?
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end
end
