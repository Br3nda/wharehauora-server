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
  validates :gateway_mac_address, uniqueness: true

  def provision_mqtt!
    return if gateway_mac_address.blank?

    ActiveRecord::Base.transaction do
      mu = MqttUser.where(home: self).first_or_initialize
      mu.provision!
      mu.save!
    end
  end
end
