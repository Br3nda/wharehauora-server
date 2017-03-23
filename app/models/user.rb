# frozen_string_literal: true
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :email, presence: true

  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :home_viewers, dependent: :destroy
  has_one :mqtt_user

  # TODO: homes they own as well
  has_many :homes, through: :home_viewers

  def role?(role)
    roles.any? { |r| r.name == role }
  end

  def provision_mqtt
    mqtt_password = "#{random_password 3}-#{random_password 3}-#{random_password 3}"
    Mqtt.provision_mqtt_user email, mqtt_password
    if mqtt_user
      mqtt_user.update(password: mqtt_password, provisioned_at: Time.zone.now)
    else
      self.mqtt_user = MqttUser.create!(username: email,
                                        password: mqtt_password,
                                        provisioned_at: Time.zone.now)
    end
  end

  def random_password(length)
    (0...length).map { (65 + rand(26)).chr }.join
  end
end
