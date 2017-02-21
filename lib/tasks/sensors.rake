require 'mqtt'
require 'uri'

namespace :sensors do
  desc 'Subscribe to incoming sensor messages'
  task ingest: :environment do
    begin
      SensorsIngest.new.process
    rescue Exception => e # rubocop:disable Lint/RescueException
      Raygun.track_exception(e) if Rails.env.production?
      raise
    end
  end
  task fake: :environment do
    SensorsIngest.new.fake
  end
end

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

  def fake
    @previous_values = {}
    loop do
      Sensor.all.each do |sensor|
        save_reading(sensor, MySensors::SetReq::V_TEMP, fake_temperature(sensor.id))
        save_reading(sensor, MySensors::SetReq::V_HUM, fake_humidity(sensor.id))
      end
      sleep(10)
    end
  end

  def decode(topic, value)
    (home_id, node_id, child_sensor_id, message_type, ack, sub_type, payload) = topic.split('/')[3..-1]

    sensor = find_or_create_sensor(home_id, node_id)

    reading = Reading.create!(sensor_id: sensor.id,
                              value: value,
                              child_sensor_id: child_sensor_id,
                              message_type: message_type,
                              ack: ack,
                              sub_type: sub_type)
    puts "home id:#{home_id} sensor id:#{sensor.id} reading id:#{reading.id}"
    puts "message_type #{message_type}, ack #{ack}, sub_type #{sub_type}, payload #{payload}"
  end

  private

  def find_or_create_sensor(home_id, node_id)
    sensor = Sensor
             .where('room_id in (SELECT room_id FROM rooms WHERE home_id=?)', home_id)
             .find_by(node_id: node_id)
    unless sensor
      home = Home.find(home_id)
      room = Room.create!(name: 'New sensor detected', home: home)
      sensor = Sensor.create!(node_id: node_id, room: room)
    end

    sensor
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

  def save_reading(sensor, sub_type, value)
    reading = Reading.new(sensor_id: sensor.id,
                          value: value,
                          child_sensor_id: (sub_type == MySensors::SetReq::V_HUM ? 0 : 1),
                          message_type: MySensors::MessageType::SET,
                          sub_type: sub_type)
    reading.save!
    puts "home #{sensor.home_id} sensors #{sensor.id} reading #{reading.id} value: #{value}"
  end

  def fake_temperature(sensor_id)
    # Grab the last value for this room
    last_value = @previous_values["#{sensor_id}-#{MySensors::SetReq::V_TEMP}"] || 20

    # create a new temp, that's similar to current one
    temp = rand((last_value - 0.5)..(last_value + 0.5))
    temp = 20.0 if temp > 40 || temp < -5

    # save it for next method call
    @previous_values["#{sensor_id}-#{MySensors::SetReq::V_TEMP}"]

    temp
  end

  def fake_humidity(sensor_id)
    last_value = @previous_values["#{sensor_id}-#{MySensors::SetReq::V_HUM}"] || 65

    humidity = rand((last_value - 1.1)..(last_value + 1.1))
    humidity = 70.0 if humidity > 100 || humidity < 20

    @previous_values["#{sensor_id}-#{MySensors::SetReq::V_HUM}"]
    humidity
  end
end
