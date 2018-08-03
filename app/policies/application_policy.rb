# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def janitor?
      user.present? && user.role?('janitor')
    end
  end

  private

  def owner?
    record.joins_home.home.owner_id == user.id
  end

  def whanau?
    record.joins_home.home.users.include? user
  end

  def janitor?
    user&.role?('janitor')
  end

  def signed_in?
    user.present?
  end
end
