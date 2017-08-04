module Api
  class UsersController < BaseController
    def show
      authorize current_resource_owner
      render json: current_resource_owner, only: %i[name email created_at updated_at]
    end
  end
end
