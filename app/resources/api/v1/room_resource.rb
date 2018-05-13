module Api
  module V1
    class RoomResource < ApplicationResource
      model_name 'Room'
      attributes :name, :updated_at, :ratings, :readings, :sensor_count, :room_type, :room_type_id

      has_one :home
      has_many :sensors
      has_many :readings

      def room_type
        @model.room_type.name
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
