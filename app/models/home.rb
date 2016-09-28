# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :sensors
  belongs_to :owner
end
