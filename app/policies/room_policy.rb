class RoomPolicy < ApplicationPolicy

  class Scope < Scope
    def resolve
      scope.joins(:home).where(homes: { owner: user.id })
    end
  end

  private

  def owned_by_current_user
    record.home.owner_id == user.id
  end
end