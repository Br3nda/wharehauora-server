class HomeViewerPolicy < ApplicationPolicy
  def index?
    owner? || janitor?
  end

  def new?
    owner? || janitor?
  end

  def edit?
    owner? || janitor?
  end

  def show?
    owner? || janitor?
  end

  def update?
    owner? || janitor?
  end

  def destroy?
    owner? || janitor?
  end

  class Scope < Scope
    def resolve
      scope.all if user
    end
  end

  def owner?
    record.owner_id == user.owner_id
  end
end
