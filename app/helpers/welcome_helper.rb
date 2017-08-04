# frozen_string_literal: true

module WelcomeHelper
  # def frontpage_temperature(temperature)
  #   return '??.?' if temperature.blank?
  #   format('%.1fC', temperature)
  # end

  # def frontpage_humidity(humidity)
  #   return '??.?' if humidity.blank?
  #   format('%.1f%%', humidity)
  # end

  # def too_cold?(temperature, room_type)
  #   temperature.present? && room_type.min_temperature.present? && (temperature < room_type.min_temperature)
  # end

  # def frontpage_conditions_classname(temperatures, home_type, room_types)
  #   room_types.each do |room_type|
  #     if room_type.min_temperature.present?
  #       t = temperatures[[home_type.id, room_type.id]]
  #       return 'conditions-table conditions-table-bad' if t.present? && t < room_type.min_temperature
  #     end
  #   end
  #   'conditions-table conditions-table-good'
  # end
end
