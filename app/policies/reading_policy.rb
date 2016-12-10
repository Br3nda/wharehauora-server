class ReadingPolicy < ApplicationPolicy
  def create?
    owned_by_current_user?
  end

  def new?
    user.present?
  end

  def edit?
    owned_by_current_user?
  end

  def show?
    owned_by_current_user?
  end

  def update?
    owned_by_current_user?
  end

  def destroy?
    owned_by_current_user?
  end

  class Scope < Scope
    def resolve
      scope.joins(:sensor, sensor: :home).where('homes.owner_id': user.id)
    end
  end

  private

  def owned_by_current_user?
    record.sensor.home.owner_id == user.id
  end
end
