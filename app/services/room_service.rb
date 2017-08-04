class RoomService
  def initialize(room)
    @room = room
  end

  def summary
    Rails.cache.fetch("#{@room.cache_key}/summary/#{@room.updated_at}", expires_in: 60.minutes) do
      {
        sensors_count: @room.sensors.size,
        readings: readings,
        ratings: ratings
      }
    end
  end

  private

  def ratings
    {
      good: @room.good?,
      min_temperature: @room.room_type&.min_temperature,
      max_temperature: @room.room_type&.max_temperature,
      too_cold: @room.too_cold?,
      too_hot: @room.too_hot?,
      too_damp: @room.below_dewpoint?,
      bit_damp: @room.near_dewpoint?
    }
  end

  def readings
    readings = {}
    %w[temperature humidity dewpoint].each do |key|
      readings[key] = reading_data key
    end
    readings
  end

  def reading_data(key)
    @reading = @room.most_recent_reading(key)
    return unless @reading
    {
      value: format('%.1f', @reading.value).to_f,
      unit: @reading.unit,
      timestamp: @reading.created_at,
      current: @reading.current?
    }
  end
end
