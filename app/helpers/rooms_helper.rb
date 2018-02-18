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

  TEMPERATURE = { hot: '', ok: 'temp-mid-a', cold: 'temp-low-1a' }.freeze
  HUMIDTY = { wet: 'hum-high-2a', damp: 'hum-high-2a', ok: 'hum-mid-a' }.freeze

  def temperature_class(room)
    return TEMPERATURE[:cold] if room.too_cold?
    return TEMPERATURE[:hot] if room.too_hot?
    TEMPERATURE[:ok]
  end

  def humidity_class(room)
    return HUMIDTY[:wet] if room.below_dewpoint?
    return HUMIDTY[:damp] if room.near_dewpoint?
    HUMIDTY[:ok]
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
