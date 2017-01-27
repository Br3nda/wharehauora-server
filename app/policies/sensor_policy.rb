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
      return scope.joins(:home).where(homes: { owner_id: user.id }) if user
      scope.joins(:home).where(homes: { is_public: true })
    end
  end

  def owned_by_current_user?
    record.home.owner_id == user.id
  end
end
