# frozen_string_literal: true

class HomeType < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :homes
end
