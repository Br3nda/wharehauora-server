class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  def index?
    true
  end

  def create?
    return true if admin?
    owned_by_current_user?
  end

  def new?
    return true if admin?
    user.present?
  end

  def edit?
    return true if admin?
    owned_by_current_user?
  end

  def show?
    return true if admin?
    record.is_public? || owned_by_current_user? || current_user_authorised_to_view?
  end

  def update?
    return true if admin?
    owned_by_current_user?
  end

  def destroy?
    return true if admin?
    owned_by_current_user?
  end

  private

  class Scope < Scope
    def resolve
      return scope.is_public? if user.nil?
      return scope.all if user.present? && user.role?('janitor')
      my_homes_only
    end

    def my_homes_only
      homes = my_home_ids
      return scope.where('is_public=true OR owner_id = ? or id in (?)', user.id, homes) if homes.count.positive?
      scope.where('is_public=true OR owner_id = ? ', user.id)
    end

    def my_home_ids
      HomeViewer.where(user_id: user.id).pluck(:home_id)
    end
  end

  def owned_by_current_user?
    record.owner_id == user.id if user.present?
  end

  def current_user_authorised_to_view?
    record.users.include?(user)
  end
end
