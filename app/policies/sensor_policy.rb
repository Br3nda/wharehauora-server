class SensorPolicy < ApplicationPolicy
  def show?
    owned_by_current_user?
  end
  def destroy?
    owned_by_current_user? || user.role?('janitor')
  end

  private

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

  def owned_by_current_user?
    record.home.owner_id == user.id
  end
end
