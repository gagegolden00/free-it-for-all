class UserPolicy < ApplicationPolicy
  

  def initialize(user, new_user)
    @user = user
    @new_user = new_user
  end

  def new?
    user.admin?
  end

  def create?
    user.admin?
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
end
