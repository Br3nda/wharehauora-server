# frozen_string_literal: true

module Api
  module V1
    class RoomTypeResource < ApplicationResource
      model_name 'RoomType'
      attribute :name
    end
  end
end
