# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :home, counter_cache: true
  belongs_to :room_type, optional: true

  has_many :readings
  has_many :sensors

  has_one :home_type, through: :home
  has_one :owner, through: :home

  validates :home, presence: true
  validates :name, presence: true

  scope(:with_no_readings, -> { includes(:readings).where(readings: { id: nil }) })
  scope(:with_no_sensors, -> { includes(:sensors).where(sensors: { id: nil }) })

  scope(:has_readings, -> { includes(:sensors).where.not(sensors: { id: nil }) })

  def public?
    home.is_public
  end

  def rating
    Rails.cache.fetch("#{cache_key}/rating", expires_in: 10.minutes) do
      number = 100
      return '?' unless enough_info_to_perform_rating?

      number -= 20 if too_cold?
      number -= 40 if way_too_cold?
      number -= 40 if below_dewpoint?
      RoomService.rating_letter(number)
    end
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

  def mould
    single_current_metric 'mould'
  end

  def below_dewpoint?
    Rails.cache.fetch("#{cache_key}/below_dewpoint?", expires_in: 1.minute) do
      return false if temperature.nil? || dewpoint.nil?

      temperature < dewpoint
    end
  end

  def near_dewpoint?
    Rails.cache.fetch("#{cache_key}/near_dewpoint?", expires_in: 1.minute) do
      return false if temperature.nil? || dewpoint.nil?

      (temperature - 2) < dewpoint
    end
  end

  def dry?
    Rails.cache.fetch("#{cache_key}/dry?", expires_in: 1.minute) do
      !below_dewpoint? && !near_dewpoint?
    end
  end

  def good?
    Rails.cache.fetch("#{cache_key}/good?", expires_in: 1.minute) do
      return false unless enough_info_to_perform_rating?
      return false if below_dewpoint? || too_cold? || too_hot?

      true
    end
  end

  def too_cold?
    Rails.cache.fetch("#{cache_key}/too_cold?", expires_in: 1.minute) do
      (temperature < room_type.min_temperature) if enough_info_to_perform_rating?
    end
  end

  def way_too_cold?
    Rails.cache.fetch("#{cache_key}/way_too_cold?", expires_in: 1.minute) do
      (temperature < (room_type.min_temperature - 5)) if enough_info_to_perform_rating?
    end
  end

  def too_hot?
    Rails.cache.fetch("#{cache_key}/too_hot?", expires_in: 1.minute) do
      (temperature > room_type.max_temperature) if enough_info_to_perform_rating?
    end
  end

  def comfortable?
    Rails.cache.fetch("#{cache_key}/comfortable?", expires_in: 1.minute) do
      !too_hot? && !too_cold?
    end
  end

  def sensor?
    sensors.size.positive?
  end

  def current?(key)
    age = age_of_last_reading(key)
    age.present? && age < 1.hour
  end

  def age_of_last_reading(key)
    Rails.cache.fetch("#{cache_key}/age_of_last_readings", expires_in: 1.minute) do
      return unless readings.where(key: key).size.positive?

      Time.current - last_reading_timestamp(key)
    end
  end

  def most_recent_reading(key)
    Reading.where(room_id: id, key: key)&.last
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
