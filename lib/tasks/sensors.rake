
namespace :sensors do
  desc "Subscribe to incoming sensor messages"
  task ingest: :environment do
    SensorsIngest.new.process
  end
end

require 'mqtt'
require 'uri'

class SensorsIngest
  def process
    MQTT::Client.connect(connection_options) do |c|
      # The block will be called when you messages arrive to the topic
      c.get('/sensors/#') do |topic, message|
        puts topic
        decode topic, message
      end
    end
  end

  def decode(topic, value)
    (home_id, node_id, child_sensor_id, message_type, ack, sub_type, _payload) = topic.split("/")[3..-1]

    sensor = Sensor.find_or_create_by(home_id: home_id, node_id: node_id)

    reading = Reading.new(sensor_id: sensor.id,
                          value: value,
                          child_sensor_id: child_sensor_id,
                          message_type: message_type,
                          ack: ack,
                          sub_type: sub_type)
    reading.save!
    puts "home #{sensor.home_id} sensors #{sensor.id} reading #{reading.id}"
  end

  def connection_options
    # Create a hash with the connection parameters from the URL
    uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
    {
      remote_host: uri.host,
      remote_port: uri.port,
      username: uri.user,
      password: uri.password
    }
  end
end
