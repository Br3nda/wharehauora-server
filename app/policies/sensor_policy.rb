# frozen_string_literal: true

class SensorPolicy < ApplicationPolicy
  def show?
    owner? || janitor? || whanau?
  end

  def edit?
    owner? || janitor?
  end

  def update?
    owner? || janitor?
  end

  def destroy?
    owner? || janitor?
  end

  def unassign?
    edit?
  end

  private

  class Scope < Scope
    def resolve
      if user.janitor?
        scope.all
      elsif user
        owned_and_whanau_homes
      else
        public_homes
      end
    end

    private

    def public_homes
      scope.joins(:home).where(homes: { is_public: true })
    end

    def owned_and_whanau_homes
      scope.joins(:home)
           .joins('LEFT OUTER JOIN home_viewers ON homes.id = home_viewers.home_id')
           .where('(homes.owner_id = ? OR home_viewers.user_id = ?)', user.id, user.id)
    end
  end

  def owner?
    user.present? && (record.home.owner_id == user.id)
  end

  def whanau?
    user.present? && record.home.users.include?(user)
  end
end
