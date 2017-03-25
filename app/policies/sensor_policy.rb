class SensorPolicy < ApplicationPolicy
  def show?
    owner? || janitor? || whanau?
  end

  def destroy?
    owner? || user.role?('janitor')
  end

  private

  class Scope < Scope
    def resolve
      query = scope.joins_home
      if user
        query.where('owner_id = ? OR is_public = true')
      else
        query.where(is_public: true)
      end
      query
    end
  end

  def owner?
    record.home.owner_id == user.id
  end

  def whanau?
    record.home.users.include? user
  end

  def janitor?
    user.role? 'janitor'
  end
end
