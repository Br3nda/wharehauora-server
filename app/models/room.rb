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
    true
  end

  def last_reading_timestamp
    readings.order(created_at: :desc).first&.created_at
  end

  def rating
    'not calculated yet'
  end

  private

  def single_current_metric(key)
    Reading.where(room_id: id, key: key).last.value
  rescue
    nil
  end
end
