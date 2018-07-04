# frozen_string_literal: true

require 'digest'
class MqttUser < ActiveRecord::Base
  belongs_to :home
  validates :username, presence: true, uniqueness: true
  validates :home, presence: true, uniqueness: true
  validates :password, presence: true

  after_initialize :default_values
  after_create :provision_user
  after_destroy :unprovision_user

  def provision_user
    raise "Can't provision an invalid user" unless valid?
    Mqtt.create_user(username, password)
    Mqtt.grant_topic_access(username, topic)
    update(provisioned_at: Time.zone.now)
  end

  def unprovision_user
    Mqtt.delete_user(username)
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
