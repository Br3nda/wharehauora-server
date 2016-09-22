# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :rooms
  has_many :users
end
