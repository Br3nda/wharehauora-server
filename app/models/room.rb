# frozen_string_literal: true
class Room < ActiveRecord::Base
  has_many :sensors
  belongs_to :home
end
