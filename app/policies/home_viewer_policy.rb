class HomeViewerPolicy < ApplicationPolicy
  def index?
    home_owner? || user.role?('janitor')
  end

  def new?
    home_owner? || user.role?('janitor')
  end

  def edit?
    home_owner? || user.role?('janitor')
  end

  def show?
    home_owner? || user.role?('janitor')
  end

  def update?
    home_owner? || user.role?('janitor')
  end

  def destroy?
    home_owner? || user.role?('janitor')
  end

  class Scope < Scope
    def resolve
      scope.all if user
    end
  end

  def home_owner?
    record.owner_id == user.owner_id
  end
end
