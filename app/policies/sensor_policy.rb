class SensorPolicy < ApplicationPolicy
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
