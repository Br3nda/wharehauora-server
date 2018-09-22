# frozen_string_literal: true

module SensorsHelper
  def sensor_last_message(sensor)
    return '' unless sensor.messages.size.positive?

    "#{time_ago_in_words sensor.last_message} ago"
  end

  def sensor_first_detected(sensor)
    sensor.created_at.localtime.strftime('%Y-%m-%d')
  end
end
