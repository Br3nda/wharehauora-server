# frozen_string_literal: true

module Api
  module V1
    class HomeTypeResource < ApplicationResource
      model_name 'HomeType'
      attribute :name
    end
  end
end
