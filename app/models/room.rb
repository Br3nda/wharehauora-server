class Room < ActiveRecord::Base
  belongs_to :home, counter_cache: true
  belongs_to :room_type

  has_many :readings
  has_many :sensors

  has_one :home_type, through: :home
  has_one :owner, through: :home

  validates :home, presence: true

  scope(:without_readings, -> { includes(:readings).where(readings: { id: nil }) })
  scope(:without_sensors, -> { includes(:sensors).where(sensors: { id: nil }) })

  def temperature
    single_current_metric 'temperature'
  end

  def humidity
    single_current_metric 'humidity'
  end

  def dewpoint
    temp_c = single_current_metric 'temperature'
    humidity = single_current_metric 'humidity'
    l = Math.log(humidity / 100.0)
    m = 17.27 * temp_c
    n = 237.3 + temp_c
    b = (l + (m / n)) / 17.27
    dewpoint_c = (237.3 * b) / (1 - b)
    dewpoint_c
  end

  def below_dewpoint?
    temperature < dewpoint
  end

  def mould
    single_current_metric 'mould'
  end

  def coldest
    readings.where(key: 'temperature').order(:value)
  end

  def dampest
    readings.where(key: 'humidity').order(value: :desc)
  end

  def good?
    return unless room_type && current?('temperature')
    return unless room_type.min_temperature && room_type.max_temperature
    (temperature > room_type.min_temperature) && (temperature < room_type.max_temperature)
  end

  def too_cold?
    return unless room_type && current?('temperature') && room_type.min_temperature
    (temperature < room_type.min_temperature)
  end

  def too_hot?
    return unless room_type && current?('temperature') && room_type.max_temperature
    (temperature > room_type.max_temperature)
  end

  def current?(reading_type)
    return false unless readings.where(key: reading_type).size.positive?
    age_of_last_reading(reading_type) < 1.hour
  end

  def age_of_last_reading(reading_type)
    return nil unless readings.where(key: reading_type).size.positive?
    Time.current - last_reading_timestamp(reading_type)
  end

  def last_reading_timestamp(reading_type)
    readings.where(key: reading_type)
            .order(created_at: :desc)
            .limit(1)
            .first&.created_at
  end

  private

  def single_current_metric(key)
    Reading.where(room_id: id, key: key)&.last&.value
  end
end
