class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  class Scope < Scope
     def resolve
       scope.joins('left join authorizedviewers on authorizedviewers.home_id = homes.id').where('authorizedviewers.user_id = ? or homes.owner_id = ?',user.id,user.id)
       # auth_to_view = scope.where(user_id: user.id).joins(:home)
     end
   end

  private

  def owned_by_current_user?
    return true if record.is_public
    return record.owner_id == user.id if user
  end

  def current_user_authorised_to_view?
    record.users.include?(user)
  end

  def is_public?
    return true if record.is_public
  end

end
