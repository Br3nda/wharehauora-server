# frozen_string_literal: true

module Api
  module V1
    class RoomResource < ApplicationResource
      model_name 'Room'
      attribute :name
      attribute :updated_at
      attribute :ratings
      attribute :readings
      attribute :sensor_count
      attribute :room_type_name
      attribute :room_type_id
      attribute :home_id
      attribute :home_name

      has_one :home
      has_one :owner
      has_many :sensors
      has_many :readings

      filters :room_type_id, :home_id

      def home_name
        @model.home.name
      end

      def room_type_name
        @model.room_type.name if @model.room_type.present?
      end

      def sensor_count
        @model.sensors.size
      end

      def ratings
        room_cache 'ratings' do
          RoomService.ratings(@model)
        end
      end

      def readings
        room_cache 'readings' do
          RoomService.readings(@model)
        end
      end

      def room_cache(key)
        yield Rails.cache.fetch("#{@model.cache_key}/#{key}/#{@model.updated_at}", expires_in: 60.minutes)
      end
    end
  end
end
