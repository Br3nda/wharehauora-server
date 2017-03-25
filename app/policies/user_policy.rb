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
    janitor?
  end

  def update?
    janitor?
  end

  def destroy?
    janitor?
  end

  class Scope < Scope
    def resolve
      scope.all if janitor?
    end
  end
end
