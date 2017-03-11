class ReadingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      query = scope.joins_home
      if user
        query.where('owner_id = ? OR is_public = true', user.id)
      else
        query.where(is_public: true)
      end
    end
  end
end
