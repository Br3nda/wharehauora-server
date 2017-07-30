class Room < ActiveRecord::Base
  belongs_to :home, counter_cache: true
  belongs_to :room_type

  has_many :readings
  has_many :sensors

  has_one :home_type, through: :home
  has_one :owner, through: :home

  validates :home, presence: true

  scope(:with_no_readings, -> { includes(:readings).where(readings: { id: nil }) })
  scope(:with_no_sensors, -> { includes(:sensors).where(sensors: { id: nil }) })

  def public?
    home.is_public
  end

  def rating
    number = 100
    return '?' unless enough_info_to_perform_rating?
    number -= 15 if too_cold?
    number -= 40 if below_dewpoint?
    rating_letter(number)
  end

  def temperature
    single_current_metric 'temperature'
  end

  def humidity
    single_current_metric 'humidity'
  end

  def dewpoint
    single_current_metric 'dewpoint'
  end

  def below_dewpoint?
    return false if temperature.nil? || dewpoint.nil?
    Rails.cache.fetch("#{cache_key}/below_dewpoint?", expires_in: 1.minute) do
      temperature < dewpoint
    end
  end

  def near_dewpoint?
    return false if temperature.nil? || dewpoint.nil?
    (temperature - 2) < dewpoint
  end

  def mould
    single_current_metric 'mould'
  end

  def good?
    Rails.cache.fetch("#{cache_key}/good?", expires_in: 5.minutes) do
      return false unless enough_info_to_perform_rating?
      return false if below_dewpoint? || too_cold? || too_hot?
      true
    end
  end

  def too_cold?
    (temperature < room_type.min_temperature) if enough_info_to_perform_rating?
  end

  def too_hot?
    (temperature > room_type.max_temperature) if enough_info_to_perform_rating?
  end

  def sensor?
    sensors.size.positive?
  end

  def current?(key)
    age = age_of_last_reading(key)
    age.present? && age < 1.hour
  end

  def age_of_last_reading(key)
    return nil unless readings.where(key: key).size.positive?
    Time.current - last_reading_timestamp(key)
  end

  def last_reading_timestamp(key)
    readings.where(key: key)
            .order(created_at: :desc)
            .limit(1)
            .first&.created_at
  end

  def single_current_metric(key)
    most_recent_reading(key)&.value
  end

  def most_recent_reading(key)
    Rails.cache.fetch("#{cache_key}/reading/#{key}", expires_in: 10.seconds) do
      Reading.where(room_id: id, key: key)&.last
    end
  end

  # private

  def rating_letter(number)
    return 'A' if number > 95
    return 'B' if number > 75
    return 'C' if number > 50
    return 'D' if number > 25
    'F'
  end

  def enough_info_to_perform_rating?
    room_type && current?('temperature') && room_type.min_temperature.present? && room_type.max_temperature.present?
  end

  def calculate_dewpoint
    temp_c = single_current_metric 'temperature'
    humidity = single_current_metric 'humidity'
    return unless temp_c && humidity
    l = Math.log(humidity / 100.0)
    m = 17.27 * temp_c
    n = 237.3 + temp_c
    b = (l + (m / n)) / 17.27
    (237.3 * b) / (1 - b)
  end
end
