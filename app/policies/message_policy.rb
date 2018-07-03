# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  def index?
    signed_in?
  end

  private

  class Scope < Scope
    def resolve
      query = scope.joins_home
      if user.role? 'janitor'
        query
      elsif user
        query.where('owner_id = ? OR is_public = true', user.id)
      else
        query.where(is_public: true)
      end
    end
  end

  def owner?
    record.sensor.home.owner_id == user.id
  end

  def whanau?
    record.sensor.home.users.include? user
  end

  def janitor?
    user.role? 'janitor'
  end
end
