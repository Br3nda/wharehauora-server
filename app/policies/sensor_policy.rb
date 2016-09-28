class SensorPolicy < ApplicationPolicy
  private

  def owned_by_current_user?
    record.home.owner_id == user.id
  end
end
