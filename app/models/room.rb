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

  def mould
    single_current_metric 'mould'
  end

  def good?
    return unless room_type && current?('temperature')
    return unless room_type.min_temperature
    return unless room_type.max_temperature
    (temperature > room_type.min_temperature) && (temperature < room.max_temperature)
  end

  def current?(reading_type)
    return false unless readings.size.positive?
    age_of_last_reading(reading_type) < 1.hour
  end

  def age_of_last_reading(reading_type)
    return nil unless readings.size.positive?
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
