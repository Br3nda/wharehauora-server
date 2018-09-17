# frozen_string_literal: true

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

  def temperature_reading_class(room)
    if room.too_cold?
      'temp-low-2a'
    elsif room.too_hot?
      'temp-high-1a'
    else
      'temp-mid-a'
    end
  end

  def humidity_reading_class(room)
    if room.below_dewpoint?
      'hum-high-2a'
    elsif room.near_dewpoint?
      'hum-high-2b'
    else
      'hum-mid-a'
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
