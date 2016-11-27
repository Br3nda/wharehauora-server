class AuthorizedviewerPolicy < ApplicationPolicy
  attr_reader :user, :home
  class Scope
    attr_reader :user, :scope
    def resolve
      scope.where(user_id: user.id).joins(:home)
    end

    def initialize(user, scope)
      @user = user
      @scope = scope
    end
  end

  private

  def owned_by_current_user?
    false
  end

  def current_user_authorised_to_view?
    record.users.include?(user)
  end

  def is_public?
    return true if record.is_public
  end

end
