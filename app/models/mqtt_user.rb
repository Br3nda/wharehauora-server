class MqttUser < ActiveRecord::Base
  belongs_to :user
  validates :username, presence: true
  validates :username, uniqueness: true
end
