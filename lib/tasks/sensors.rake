
namespace :sensors do
  desc "Subscribe to incoming sensor messages"
  task subscribe: :environment do
    SensorsSubscriber.new.process
  end
end

require 'mqtt'
require 'uri'

class SensorsSubscriber
  def process
    MQTT::Client.connect(connection_options) do |c|
      # The block will be called when you messages arrive to the topic
      c.get('/sensors/#') do |topic, message|
        decode topic, message
      end
    end
   end

  def decode(topic, value)
    puts topic.to_s

    (home_id, node_id, child_sensor_id, message_type, ack, sub_type, payload) = topic.split("/")[3..-1]

    sensor = Sensor.find_or_create_by(home_id: home_id, node_id: node_id)
    puts "Sensor = #{sensor.id}"
    puts "\t#{value}"

    reading = Reading.new(sensor_id: sensor.id, value: value, message_type: message_type)
    reading.save!
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
