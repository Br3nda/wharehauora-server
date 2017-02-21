class ReadingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      query = scope.joins('INNER JOIN sensors ON readings.sensor_id = sensors.id')
                   .joins('INNER JOIN rooms ON sensors.room_id = rooms.id')
                   .joins('INNER JOIN homes ON rooms.home_id = homes.id')
      if user
        query.where('owner_id = ? OR is_public = true')
      else
        query.where(is_public: true)
      end
      query
    end
  end

  private

  def owned_by_current_user?
    record.sensor.home.owner_id == user.id
  end
end
