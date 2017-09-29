# frozen_string_literal: true

class Home < ActiveRecord::Base
  acts_as_paranoid # soft deletes, sets deleted_at column
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

  def provision_mqtt!
    ActiveRecord::Base.transaction do
      self.mqtt_user = MqttUser.where(home: self).first_or_initialize
      mqtt_user.provision!
    end
  end
end
