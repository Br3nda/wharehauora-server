class Metric < ActiveRecord::Base
  belongs_to :room
  scope :temperature, -> { where(key: 'temperature') }
  scope :humidity, -> { where(key: 'humidity') }
  scope :mould, -> { where(key: 'mould') }
end
