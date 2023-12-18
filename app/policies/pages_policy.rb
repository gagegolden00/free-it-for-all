class PagesPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def home?
    user.admin? || user.technician? 
  end
end
