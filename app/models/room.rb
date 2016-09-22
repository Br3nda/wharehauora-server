class Room < ActiveRecord::Base
	has_many :sensors
	belongs_to :home
end
