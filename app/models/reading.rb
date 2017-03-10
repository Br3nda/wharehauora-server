class Reading < ActiveRecord::Base
  belongs_to :sensor
  delegate :home, :home_id, to: :sensor, allow_nil: false
  scope :temperature, -> { where(sub_type: MySensors::SetReq::V_TEMP) }
  scope :humidity, -> { where(sub_type: MySensors::SetReq::V_HUM) }

  validates :key, :value, :sensor, presence: true
end
