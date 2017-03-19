class HomeType < ActiveRecord::Base
  validates :name, uniqueness: true
  has_many :homes
end
