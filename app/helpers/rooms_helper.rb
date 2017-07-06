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
end
