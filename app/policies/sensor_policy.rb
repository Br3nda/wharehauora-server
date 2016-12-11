class SensorPolicy < ApplicationPolicy
  def show?
    owned_by_current_user?
  end

  def update?
    owned_by_current_user?
  end

  private

  class Scope < Scope
    def resolve
      scope.joins(:home).where(homes: { owner_id: user.id })
    end
  end

  def owned_by_current_user?
    record.home.owner_id == user.id
  end
end
