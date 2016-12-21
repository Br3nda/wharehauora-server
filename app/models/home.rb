# frozen_string_literal: true
class Home < ActiveRecord::Base
  has_many :sensors
  has_many :readings, through: :sensors
  belongs_to :owner, class_name: 'User'
  belongs_to :home_type

  has_many :home_viewers
  has_many :users, through: :home_viewers

  scope :is_public?, -> { where(is_public: true) }
end
