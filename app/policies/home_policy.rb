# frozen_string_literal: true

class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  def index?
    true
  end

  def create?
    signed_in?
  end

  def new?
    signed_in?
  end

  def edit?
    owner? || janitor?
  end

  def show?
    record.is_public? || owner? || whanau? || janitor?
  end

  def update?
    return true if janitor?

    owner?
  end

  def destroy?
    return true if janitor?

    owner?
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

  def owner?
    record.owner_id == user.id if user.present?
  end

  def whanau?
    record.users.include?(user)
  end
end
