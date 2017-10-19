class Api::V1::BaseController < JSONAPI::ResourceController
  include Pundit::ResourceController
  before_action :doorkeeper_auth!

  private

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def current_user
    current_resource_owner if doorkeeper_token
    super
  end

  def doorkeeper_auth!
    doorkeeper_authorize! if doorkeeper_token
  end
end
