# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :sensors
  has_many :readings, through: :sensors
  belongs_to :owner
  belongs_to :home_type
  belongs_to :suburb
  has_many :weather_conditions, through: :suburbs

  has_many :home_viewers
  has_many :users, through: :home_viewers

  scope :is_public?, -> { where(is_public: true) }
end
