class Suburb < ActiveRecord::Base
  has_many :homes
  has_many :weather_conditions
end
