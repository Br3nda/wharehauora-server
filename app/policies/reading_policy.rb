# frozen_string_literal: true

class ReadingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      query = scope.joins_home
      if user
        query.where('owner_id = ? OR homes.is_public = true', user.id)
      else
        query.where(homes: { is_public: true })
      end
    end
  end
end
