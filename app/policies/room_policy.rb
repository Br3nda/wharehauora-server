class RoomPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.joins(:home).where(homes: { owner: user.id })
    end
  end

  private

  def owned_by_current_user?
    home = Home.find(record.home_id)
    home.owner_id == user.id
  end
end
