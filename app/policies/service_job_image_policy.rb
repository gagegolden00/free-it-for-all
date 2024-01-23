class ServiceJobImagePolicy < ApplicationPolicy

  attr_reader :user, :image

  def initialize(user, image)
    @user = user
    @image = image
  end

  def create?
    user.admin? || user.technician?
  end

  def index?
    user.admin? || user.technician?
  end

  def destroy?
    user.admin?
  end

  def show?
    user.admin? || user.technician?
  end
  
class Scope < Scope
  # NOTE: Be explicit about which records you allow access to!
  # def resolve
  #   scope.all
  # end
end
end

