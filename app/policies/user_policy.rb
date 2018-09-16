# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    janitor?
  end

  def new?
    janitor?
  end

  def edit?
    janitor?
  end

  def show?
    janitor? || user == record
  end

  def update?
    janitor?
  end

  def destroy?
    janitor?
  end

  class Scope < Scope
    def resolve
      return scope.all if janitor?

      # return scope.where(id: user.id) if user.present?
      scope.none
    end
  end
end
