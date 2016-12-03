class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  private

  class Scope < Scope
    def resolve
      return scope.where('is_public = TRUE') if user.nil?
      return scope.all if user.role? 'janitor'
      scope.where('owner_id = ? OR is_public = TRUE', user.id)
    end
  end

  def owned_by_current_user?
    return true if record.is_public
    return record.owner_id == user.id if user
  end
end
