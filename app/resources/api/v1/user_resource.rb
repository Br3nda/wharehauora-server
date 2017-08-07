module Api
  module V1
    class UserResource < ApplicationResource
      model_name 'User'
      attribute :email
    end
  end
end
