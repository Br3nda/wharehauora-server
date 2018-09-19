# frozen_string_literal: true

class MqttUserPolicy < ApplicationPolicy
  def index?
    janitor?
  end

  def create?
    janitor?
  end

  class Scope < Scope
    def resolve
      scope.all if user&.role?('janitor')
      scope.none
    end
  end

  def janitor?
    user&.role?('janitor')
  end
end
