# frozen_string_literal: true

####
#### Note, not inheriting from Application Controller
# Leaves out all the devise and ssl
class Gateway::ConfigController < ActionController::Base
  def show
    @server = Mqtt.mqtt_api_creds.hostname
    @port = Mqtt.mqtt_api_creds.port
    render inline: "#{@server}:#{@port}"
  end
end
