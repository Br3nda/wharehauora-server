# frozen_string_literal: true

class Home < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :home_type

  has_one :mqtt_user

  has_many :rooms
  has_many :messages, through: :sensors

  has_many :sensors
  has_many :readings, through: :rooms

  has_many :home_viewers

  has_many :users, through: :home_viewers

  has_many :invitations

  scope(:is_public?, -> { where(is_public: true) })

  validates :name, presence: true
  validates :owner, presence: true
  validates :gateway_mac_address, uniqueness: true, allow_nil: true

  def provision_mqtt!
    ActiveRecord::Base.transaction do
      # If we have a user and the username doesn't match, get rid of it
      mqtt_user.delete if mqtt_user.present? && mqtt_user.username != gateway_mac_address
      self.mqtt_user = MqttUser.first_or_create(home_id: id)
    end
  end
end
