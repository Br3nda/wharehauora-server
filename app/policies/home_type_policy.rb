class HomeTypePolicy < ApplicationPolicy
  def index?
    user.role?('janitor')
  end

  def new?
    user.role?('janitor')
  end

  def create?
    user.role?('janitor')
  end

  def edit?
    user.role?('janitor')
  end

  def show?
    user.role?('janitor')
  end

  def update?
    user.role?('janitor')
  end

  def destroy?
    user.role?('janitor')
  end

  class Scope < Scope
    def resolve
      scope.all if user && user.role?('janitor')
    end
  end
end
