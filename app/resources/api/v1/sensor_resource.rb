# frozen_string_literal: true

module Api
  module V1
    class SensorResource < ApplicationResource
      model_name 'Sensor'
      # has_one :home
      # has_one :room

      attribute :node_id
      attribute :home_id
      attribute :room_id
      attribute :owner_id
      attribute :created_at
      attribute :messages_count

      def owner_id
        @model.home.owner_id
      end

      filters :room_id, :home_id
    end
  end
end
