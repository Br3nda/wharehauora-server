# frozen_string_literal: true

class Gateway::ConfigController < ApplicationController
  def show
    skip_authorization
    @server = Mqtt.mqtt_api_creds.hostname
    @port = Mqtt.mqtt_api_creds.port
    render inline: "#{@server}:#{@port}"
  end

  def force_ssl
    nil
  end
end
