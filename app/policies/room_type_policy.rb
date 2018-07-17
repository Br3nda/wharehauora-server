# frozen_string_literal: true

class RoomTypePolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    janitor?
  end

  def create?
    janitor?
  end

  def edit?
    janitor?
  end

  def show?
    true
  end

  def update?
    janitor?
  end

  def destroy?
    janitor?
  end

  class Scope < Scope
    def resolve
      scope.all if user && janitor?
    end
  end
end
