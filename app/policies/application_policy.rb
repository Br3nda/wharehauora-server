class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  class Scope
    attr_reader :user, :scope
    def resolve
      raise 'Policy Scope not defined'
      # scope.all if user && user.role?("janitor")
      # scope.where(owner_id: user.id)
    end

    def initialize(user, scope)
      @user = user
      @scope = scope
    end
  end
end
