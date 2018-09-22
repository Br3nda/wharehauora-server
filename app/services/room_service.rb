# frozen_string_literal: true

class RoomService
  def self.ratings(room)
    {
      good: room.good?,
      min_temperature: room.room_type&.min_temperature,
      max_temperature: room.room_type&.max_temperature,
      too_cold: room.too_cold?,
      too_hot: room.too_hot?,
      too_damp: room.below_dewpoint?,
      bit_damp: room.near_dewpoint?
    }
  end

  def self.readings(room)
    readings = {}
    %w[temperature humidity dewpoint].each do |key|
      readings[key] = reading_data room, key
    end
    readings
  end

  def self.reading_data(room, key)
    reading = room.most_recent_reading(key)
    return unless reading

    {
      value: format('%.1f', reading.value).to_f,
      unit: reading.unit,
      timestamp: reading.created_at,
      current: reading.current?
    }
  end

  def self.rating_letter(number)
    return 'A' if number > 95
    return 'B' if number > 75
    return 'C' if number > 50
    return 'D' if number > 25

    'F'
  end
end
