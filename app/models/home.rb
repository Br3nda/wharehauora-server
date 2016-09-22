class Home < ActiveRecord::Base
	has_many :rooms
	has_many :users
end
