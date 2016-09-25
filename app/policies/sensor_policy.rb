class SensorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:room, room: :home).where('homes.owner_id': user.id)
    end
  end

  private

  def owned_by_current_user
    record.room.home.owner_id == user.id
  end
end
