module Api
  class RoomResource < ApplicationResource
    model_name 'Room'
    attributes :name, :updated_at, :ratings, :readings, :sensor_count
    has_one :home

    def sensor_count
      @model.sensors.size
    end

    def ratings
      Rails.cache.fetch("#{@model.cache_key}/ratings/#{@model.updated_at}", expires_in: 60.minutes) do
        RoomService.ratings(@model)
      end
    end

    def readings
      Rails.cache.fetch("#{@model.cache_key}/readings/#{@model.updated_at}", expires_in: 60.minutes) do
        RoomService.readings(@model)
      end
    end
  end
end
