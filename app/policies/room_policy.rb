# frozen_string_literal: true

class RoomPolicy < ApplicationPolicy
  def edit?
    owner? || janitor?
  end

  def show?
    record.home.is_public || owner? || whanau? || janitor?
  end

  def update?
    owner? || janitor?
  end

  def destroy?
    owner? || janitor?
  end

  def summary?
    show?
  end

  def create?
    owner? || janitor?
  end

  private

  class Scope < Scope
    def resolve
      return janitor_scope if janitor?
      return user_scope if user.present?

      public_scope
    end

    private

    def janitor?
      user.present? && user.role?('janitor')
    end

    def janitor_scope
      scope.all
    end

    def user_scope
      scope.joins(:home)
           .joins('LEFT OUTER JOIN home_viewers ON homes.id = home_viewers.home_id')
           .where('(homes.owner_id = ? OR home_viewers.user_id = ? OR homes.is_public)', user.id, user.id)
    end

    def public_scope
      scope.joins(:home).where(homes: { is_public: true })
    end
  end

  def owner?
    user && record.home.owner_id == user.id
  end

  def whanau?
    record.home.users.include? user
  end
end
