class Gateway::ConfigController < ApplicationController
  def show
    skip_authorization
    @server = Mqtt.mqtt_api_creds.hostname
    @port = Mqtt.mqtt_api_creds.port
    render inline: "#{@server}:#{@port}"
  end
end
