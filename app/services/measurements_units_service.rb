class MeasurementsUnitsService
  def self.unit_for(key)
    if key == 'temperature'
      '°C'
    elsif key == 'humidity'
      '%'
    else
      'unknown unit'
    end
  end
end
