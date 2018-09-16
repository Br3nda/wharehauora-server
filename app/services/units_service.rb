# frozen_string_literal: true

class UnitsService
  def self.unit_for(key)
    if %w[temperature dewpoint].include? key
      '°C'
    elsif key == 'humidity'
      '%'
    else
      '?'
    end
  end
end
