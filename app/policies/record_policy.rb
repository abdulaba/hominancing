class RecordPolicy < ApplicationPolicy
  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      scope.all
    end
  end

  def new?
    true
  end

  def create?
    true
  end

  def edit?
    record.account.user == user
  end

  def update?
    record.account.user == user
  end

  def destroy?
    record.account.user == user
  end
end
