module RoomsHelper
  def room_temperature(room)
    t = room.temperature
    return format '%.1fC', t unless t.nil?
    '??.?'
  end

  def room_humidity(room)
    h = room.humidity
    return format '%.1f%%', h unless h.nil?
    '??.?'
  end

  def room_reading_time_ago(room, reading_type)
    ts = room.last_reading_timestamp reading_type
    "#{time_ago_in_words(ts)} ago" if ts
  end
end
