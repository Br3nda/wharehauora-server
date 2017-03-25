class Message < ActiveRecord::Base
  belongs_to :sensor

  validates :node_id, :sensor_id, :child_sensor_id,
            :message_type, :ack, :sub_type, presence: true

  after_save :save_reading

  scope :joins_home, -> { joins(:sensor, sensor: :home) }

  def self.decode(topic, payload)
    (home_id, node_id, child_sensor_id, message_type,
        ack, sub_type) = topic.split('/')[3..-1]
    home = Home.find(home_id)
    message = Message.create!(
      node_id: node_id, child_sensor_id: child_sensor_id,
      message_type: message_type, ack: ack, sub_type: sub_type,
      payload: payload,
      sensor: home.find_or_create_sensor(node_id)
    )
    message
  end

  private

  def save_reading
    Reading.create!(room: sensor.room, value: payload.to_f, key: key) if sensor.room
  end

  def key
    case child_sensor_id.to_i
    when 0
      'humidity'
    when 1
      'temperature'
    else
      'unknown'
    end
  end
end
