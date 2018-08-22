# frozen_string_literal: true

require 'mqtt'
require 'uri'

namespace :sensors do
  desc 'Subscribe to incoming sensor messages'
  task ingest: :environment do
    begin
      SensorsIngest.new.process
    rescue Exception => e
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
        puts "#{topic} #{message}"
        begin
          Message.new.decode(topic, message)
        rescue ActiveRecord::RecordNotFound => e
          puts e
        end
      end
    end
  end

  def fake
    @previous_values = {}
    loop do
      Sensor.all.each do |sensor|
        save_message(sensor, MySensors::SetReq::V_TEMP, fake_temperature(sensor))
        save_message(sensor, MySensors::SetReq::V_HUM, fake_humidity(sensor.id))
      end
      sleep(10)
    end
  end

  private

  def connection_options
    # Create a hash with the connection parameters from the URL
    uri = URI.parse ENV['CLOUDMQTT_URL'] || 'mqtt://localhost:1883'
    # the Heroku managed env variable isn't SSL
    # but we gotta be better than that!
    port = ENV['MQTT_SSL_PORT']
    {
      remote_host: uri.host,
      remote_port: port,
      username: uri.user,
      password: uri.password,
      ssl: true
    }
  end

  def save_message(sensor, message_type, value)
    message = Message.new(sensor_id: sensor.id,
                          payload: value,
                          node_id: sensor.node_id,
                          ack: 1,
                          sub_type: 1,
                          child_sensor_id: (message_type == MySensors::SetReq::V_HUM ? 0 : 1),
                          message_type: message_type)
    message.save!
    puts "home #{sensor.home_id} sensors #{sensor.id} value: #{value}"
  end

  def fake_temperature(sensor)
    # Grab the last value for this room
    last_value = sensor.room.temperature if sensor.room.present?
    last_value ||= 20.0

    # create a new temp, that's similar to current one
    new_value = last_value - 0.1
    new_value = 20.0 if new_value > 40.0 || new_value < -5.0
    new_value
  end

  def fake_humidity(sensor_id)
    last_value = @previous_values["#{sensor_id}-#{MySensors::SetReq::V_HUM}"] || 65

    humidity = rand((last_value - 1.1)..(last_value + 1.1))
    humidity = 70.0 if humidity > 100 || humidity < 20

    @previous_values["#{sensor_id}-#{MySensors::SetReq::V_HUM}"]
    humidity
  end
end
