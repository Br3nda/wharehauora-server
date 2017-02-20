class Room < ActiveRecord::Base
  belongs_to :home
  belongs_to :room_type
  has_many :metrics
  has_many :sensors

  has_many :readings, through: :sensors
  has_one :home_type, through: :home
  has_one :owner, through: :home
end
