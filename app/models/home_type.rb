# frozen_string_literal: true

class HomeType < ApplicationRecord
  validates :name, uniqueness: true
  has_many :homes
end
