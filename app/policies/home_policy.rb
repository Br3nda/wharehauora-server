class HomePolicy < ApplicationPolicy
  attr_reader :user, :home

  def create?
    owned_by_current_user?
  end

  def new?
    user.present?
  end

  def edit?
    owned_by_current_user?
  end

  def show?
    owned_by_current_user?
  end

  def update?
    owned_by_current_user?
  end

  def destroy?
    owned_by_current_user?
  end


  private

  class Scope < Scope
    def resolve
      return scope.where('is_public = TRUE') if user.nil?
      return scope.all if user.role? 'janitor'
      scope.joins('left join authorizedviewers on authorizedviewers.home_id = homes.id').where('authorizedviewers.user_id = ? or homes.owner_id = ?',user.id,user.id)
      #scope.where('owner_id = ? OR is_public = TRUE', user.id)
    end
  end

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
