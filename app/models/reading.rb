class Reading < ActiveRecord::Base
  belongs_to :sensor
  delegate :home, :home_id, to: :sensor, allow_nil: false
end
