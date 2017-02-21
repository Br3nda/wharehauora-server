class SensorPolicy < ApplicationPolicy
  def edit?
    owned_by_current_user?
  end

  def show?
    owned_by_current_user?
  end

  def update?
    owned_by_current_user?
  end

  private

  class Scope < Scope
    def resolve
      query = scope.joins('INNER JOIN rooms ON sensors.room_id = rooms.id')
                   .joins('INNER JOIN homes ON rooms.home_id = homes.id')
      if user
        query.where('owner_id = ? OR is_public = true')
      else
        query.where(is_public: true)
      end
      query
    end
  end

  def owned_by_current_user?
    record.home.owner_id == user.id
  end
end
