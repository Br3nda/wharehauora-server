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
    record.is_public? || owned_by_current_user?
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
      return scope.all if user.role? 'janitor'
      return scope.joins(:authorizedviewers).where(authorizedviewers: { user_id: user.id }) unless user.nil?
      scope.is_public?
    end
  end

  def owned_by_current_user?
    record.owner_id == user.id if user
  end

  def current_user_authorised_to_view?
    record.users.include?(user)
  end
end
