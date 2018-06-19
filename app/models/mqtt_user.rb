require 'digest'
class MqttUser < ActiveRecord::Base
  belongs_to :home
  validates :username, presence: true, uniqueness: true
  validates :home, uniqueness: true

  after_initialize :default_values

  def provision!
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

  # def new_username
  #   "whare#{home.id}"
  # end

  # def new_password
  #   "#{random_password 3}-#{random_password 3}-#{random_password 3}"
  # end

  # def random_password(length)
  #   (0...length).map { (65 + rand(26)).chr }.join
  # end
end
