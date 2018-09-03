# frozen_string_literal: true

module ReadingsHelper
  def display_reading(reading)
    unit = UnitsService.unit_for reading.key
    value = reading.value
    return '??' if value.nil?

    value = format('%.1f', value)
    "#{value}#{unit}"
  end
end
