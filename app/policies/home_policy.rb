class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  private

  def owned_by_current_user?
    return true if record.is_public
    return record.owner_id == user.id if user
  end

  def current_user_authorised_to_view?
    return record.owner_id == user.id if user
  end

  def is_public?
    return true if record.is_public
  end

end
