module RoomsHelper
  def display_temperature(room)
    display_metric room, 'temperature'
  end

  def display_humidity(room)
    display_metric room, 'humidity'
  end

  def display_dewpoint(room)
    display_metric room, 'dewpoint'
  end

  def room_quality_level(room)
    if room.rating == 'A'
      return 'high'
    elsif room.rating == 'B' || room.rating == 'C'
      return 'mid'
    else
      return 'low'
    end
  end

  def temperature_quality(room)
    if room.too_hot?
      'temperature-high-1b'
    elsif room.too_cold?
      'temperature-low-2b'
    else
      'temperature-mid-a'
    end
  end

  private

  def display_metric(room, key)
    unit = UnitsService.unit_for key
    value = room.single_current_metric key
    return '??' if value.nil?
    value = format('%.1f', value)
    "#{value}#{unit}"
  end
end
