# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :sensors
  has_many :readings, through: :sensors
  belongs_to :owner
end
