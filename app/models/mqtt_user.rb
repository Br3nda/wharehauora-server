# frozen_string_literal: true

require 'digest'
class MqttUser < ApplicationRecord
  belongs_to :home
  validates :username, presence: true, uniqueness: true
  validates :home, presence: true, uniqueness: true

  after_initialize :default_values

  def provision!
    raise "Can't provision an invalid user" unless valid?

    Mqtt.provision_user(username, password)
    Mqtt.grant_access(username, topic)
    self.provisioned_at = Time.zone.now
    save!
  end

  private

  def topic
    "/sensors/v2/#{home.gateway_mac_address}/#"
  end

  def default_values
    self.username = home.gateway_mac_address
    self.password = Digest::MD5.hexdigest("#{home.gateway_mac_address}#{salt}")
  end

  def salt
    ENV['SALT']
  end
end
