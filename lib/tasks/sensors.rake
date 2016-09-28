
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
        puts "#{topic}: #{message}"
      end
    end
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
