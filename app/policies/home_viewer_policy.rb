# frozen_string_literal: true

class HomeViewerPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all if user
    end
  end

  def owner?
    record.owner_id == user.owner_id
  end
end
