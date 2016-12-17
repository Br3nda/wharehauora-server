class HomeType < ActiveRecord::Base
  validates :name, uniqueness: true
end
