class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  private

  def owned_by_current_user?
    record.owner_id == user.id
  end
end
