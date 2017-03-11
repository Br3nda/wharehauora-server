class Room < ActiveRecord::Base
  belongs_to :home
  belongs_to :room_type
  has_many :readings
  has_many :sensors

  has_many :readings, through: :sensors
  has_one :home_type, through: :home
  has_one :owner, through: :home

  validates :home, presence: true

  def temperature
    single_current_metric 'temperature'
  end

  def humidity
    single_current_metric 'humidity'
  end

  def mould
    single_current_metric 'mould'
  end

  def last_reading_timestamp
    readings.order(created_at: :desc)
            .first
            .created_at
  rescue
    nil
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
