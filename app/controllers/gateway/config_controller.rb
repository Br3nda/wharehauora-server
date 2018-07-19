class Gateway::ConfigController < ApplicationController
  def show
    skip_authorization
    @server = Mqtt.mqtt_api_creds.hostname
    @port = ENV['MQTT_SSL_PORT']
    render inline: "#{@server}:#{@port}"
  end
end
