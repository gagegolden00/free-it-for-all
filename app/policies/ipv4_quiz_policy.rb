class Ipv4QuizPolicy < ApplicationPolicy
  def initialize(user, quiz)
    @user = user
    @quiz = quiz
  end

  def index?
    @user.present?
  end

  def show?
    @user.present?
  end

  def create?
    @user.present?
  end

  def new?
    create?
  end

  def update?
    @user.present?
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end
end

