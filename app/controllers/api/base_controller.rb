module Api
  class BaseController < ApplicationController
    before_action :doorkeeper_authorize!

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if  doorkeeper_token
    end

    def pundit_user
      current_resource_owner
    end
  end
end




