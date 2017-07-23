class RoomService
  def initialize(room)
    @room = room
  end

  def ratings
    {
      good: @room.good?,
      min_temperature: @room.room_type&.min_temperature,
      max_temperature: @room.room_type&.max_temperature,
      too_cold: @room.too_cold?,
      too_hot: @room.too_hot?
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
      value: format('%.1f', @reading.value),
      unit: @reading.unit,
      timestamp: @reading.created_at,
      current: @reading.current?
    }
  end

  def room_data
    {
      id: @room.id,
      name: @room.name,
      room_type: { name: @room.room_type&.name }
    }
  end
end
