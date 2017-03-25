class CleanerPolicy < ApplicationPolicy
  def index?
    janitor?
  end

  def rooms?
    janitor?
  end

  def sensors?
    janitor?
  end

  # class Scope < Scope
  #   def resolve
  #     scope.all if user && user.role?('janitor')
  #   end
  # end
end
