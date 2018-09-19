# frozen_string_literal: true

class HomeType < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  has_many :homes
end
