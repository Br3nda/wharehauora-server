# frozen_string_literal: true

module Api
  module V1
    class UserResource < ApplicationResource
      model_name 'User'
      attribute :email
      filters :email
    end
  end
end
