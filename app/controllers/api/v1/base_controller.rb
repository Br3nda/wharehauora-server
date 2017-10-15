class Api::V1::BaseController < JSONAPI::ResourceController
  include Pundit::ResourceController
  before_action :auth!

  private

  # def current_resource_owner
  #   User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  # end

  # def pundit_user
  #   current_resource_owner
  # end

  def auth!
    doorkeeper_authorize! if doorkeeper_token
  end
end
