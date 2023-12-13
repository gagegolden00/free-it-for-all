class PurchaseOrderPolicy < ApplicationPolicy

  def initialize(user, purchase_order)
    @user = user
    @purchase_order = purchase_order
  end

  def new?
    user.admin? || user.technician?
  end

  def create?
    user.admin? || user.technician?
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

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin? || user.technician?
        scope.all
      end
    end
    
  end
end
