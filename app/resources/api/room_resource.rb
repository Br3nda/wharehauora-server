module Api
  class RoomResource < ApplicationResource
    model_name 'Room'
    attributes :name, :updated_at, :ratings, :readings, :sensor_count
    has_one :home

    def sensor_count
      @model.sensors.size
    end

    def ratings # rubocop:disable Metrics/MethodLength
      Rails.cache.fetch("#{@model.cache_key}/ratings/#{@model.updated_at}", expires_in: 60.minutes) do
        {
          good: @model.good?,
          min_temperature: @model.room_type&.min_temperature,
          max_temperature: @model.room_type&.max_temperature,
          too_cold: @model.too_cold?,
          too_hot: @model.too_hot?,
          too_damp: @model.below_dewpoint?,
          bit_damp: @model.near_dewpoint?
        }
      end
    end

    def readings
      Rails.cache.fetch("#{@model.cache_key}/readings/#{@model.updated_at}", expires_in: 60.minutes) do
        readings = {}
        %w[temperature humidity dewpoint].each do |key|
          readings[key] = reading_data key
        end
        readings
      end
    end

    private

    def reading_data(key)
      reading = @model.most_recent_reading(key)
      return unless reading
      {
        value: format('%.1f', reading.value).to_f,
        unit: reading.unit,
        timestamp: reading.created_at,
        current: reading.current?
      }
    end
  end
end
