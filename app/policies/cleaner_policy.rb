class CleanerPolicy < ApplicationPolicy
  def index?
    user.role?('janitor')
  end

  def rooms?
    user.role?('janitor')
  end

  def sensors?
    user.role?('janitor')
  end

  class Scope < Scope
    def resolve
      scope.all if user && user.role?('janitor')
    end
  end
end
