class ReadingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      query = scope.joins_home
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
