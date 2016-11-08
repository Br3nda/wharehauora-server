class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  private

  def owned_by_current_user?
    return true if record.is_public
    return record.owner_id == user.id if user
  end
end
