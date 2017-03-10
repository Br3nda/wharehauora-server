class Message < ActiveRecord::Base
  belongs_to :sensor

  validates :node_id, :sensor_id, :child_sensor_id,
            :message_type, :ack, :sub_type, presence: true

  # scope :temperature, -> { where(sub_type: MySensors::SetReq::V_TEMP) }
  # scope :humidity, -> { where(sub_type: MySensors::SetReq::V_HUM) }

  def self.decode(topic, payload)
    (home_id, node_id, child_sensor_id, message_type,
        ack, sub_type, payload) = topic.split('/')[3..-1]
    home = Home.find(home_id)
    message = Message.new(
      node_id: node_id, child_sensor_id: child_sensor_id,
      message_type: message_type, ack: ack, sub_type: sub_type,
      payload: payload
    )
    message.sensor = home.find_or_create_sensor(node_id)
    message
  end
end
