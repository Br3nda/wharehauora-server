class MqttUser < ActiveRecord::Base
  belongs_to :home
  validates :username, presence: true, uniqueness: true
  validates :home, uniqueness: true

  after_initialize :default_values

  def provision!
    Mqtt.provision_mqtt_user username, password
    Mqtt.grant_access(username, home)

    self.provisioned_at = Time.zone.now
    save!
  end

  private

  def default_values
    self.username = new_username if username.nil?
    self.password = new_password if password.nil?
  end

  def new_username
    "whare#{home.id}"
  end

  def new_password
    "#{random_password 3}-#{random_password 3}-#{random_password 3}"
  end

  def random_password(length)
    (0...length).map { (65 + rand(26)).chr }.join
  end
end
