module RoomsHelper
  def display_temperature(_room)
    temperature = @room.temperature
    unit = UnitsService.unit_for 'temperature'
    temperature.nil? ? '??' : format("%.1f#{unit}", temperature)
  end

  def display_humidity(_room)
    humidity = @room.humidity
    humidity.nil? ? '??' : format('%.1f%%', humidity)
  end

  def display_dewpoint(_room)
    dewpoint = @room.dewpoint
    unit = UnitsService.unit_for 'temperature'
    dewpoint.nil? ? '??' : format("%.1f#{unit}", dewpoint)
  end
end
