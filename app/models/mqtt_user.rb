class MqttUser < ActiveRecord::Base
  belongs_to :user
  validates :username, presence: true
  validates :username, uniqueness: true

  def provision!
    password = new_password if password.nil?

    Mqtt.provision_mqtt_user user.email, password

    user.owned_homes.each do |home|
      Mqtt.grant_write_access(user.email, home)
    end

    self.provisioned_at = Time.zone.now

    save!
  end

  private

  def new_password
    "#{random_password 3}-#{random_password 3}-#{random_password 3}"
  end

  def random_password(length)
    (0...length).map { (65 + rand(26)).chr }.join
  end
end
