# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :rooms
  belongs_to :owner
end
