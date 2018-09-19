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

  def room_class(room)
    if room.good?
      'grade-high'
    elsif room.below_dewpoint?
      'grade-low'
    else
      'grade-mid'
    end
  end

  def reading_age_in_words(room, key)
    return unless room.readings.where(key: key).size.positive?

    "#{time_ago_in_words room.last_reading_timestamp(key)} ago"
  end

  def temperature_reading_class(room)
    return 'expired' unless room.enough_info_to_perform_rating?

    if room.too_cold?
      'temp-low-2a'
    elsif room.too_hot?
      'temp-high-1a'
    else
      'temp-mid-a'
    end
  end

  def humidity_reading_class(room)
    return 'expired' unless room.enough_info_to_perform_rating?

    if room.below_dewpoint?
      'hum-high-2a'
    elsif room.near_dewpoint?
      'hum-high-2b'
    else
      'hum-mid-a'
    end
  end

  def dewpoint_reading_class(room)
    return 'expired' unless room.enough_info_to_perform_rating?

    if room.below_dewpoint?
      'dew-high-2'
    elsif room.near_dewpoint?
      'dew-mid'
    else
      'hum-mid-a'
    end
  end

  def room_grade_class(room)
    if room.rating == 'A'
      'grade-high'
    elsif room.rating == 'B'
      'grade-high'
    elsif room.rating == 'B'
      'grade-mid'
    elsif room.rating == 'D'
      'grade-low'
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
