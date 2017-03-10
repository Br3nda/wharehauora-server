class Room < ActiveRecord::Base
  belongs_to :home
  belongs_to :room_type
  has_many :metrics
  has_many :sensors

  has_many :readings, through: :sensors
  has_one :home_type, through: :home
  has_one :owner, through: :home

  validates :home, presence: true

  def temperature
    Reading.where(room_id: id)
           .temperature
           .order(created_at: :desc)
           .first
           .value
  rescue
    nil
  end

  def humidity
    Reading.where(room_id: id)
           .humidity
           .order(created_at: :desc)
           .first
           .value
  rescue
    nil
  end

  def last_reading_timestamp
    Reading.where(room_id: id)
           .order(created_at: :desc)
           .first
           .created_at
  rescue
    nil
  end

  def mould
    Reading.where(room_id: id)
           .mould
           .order(created_at: :desc)
           .first
           .value
  rescue
    nil
  end

  def rating
    'TODO'
  end
end
