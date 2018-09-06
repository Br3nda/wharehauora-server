# frozen_string_literal: true

####
#### Note, not inheriting from Application Controller
# Leaves out all the devise and ssl
class Gateway::ConfigController < ActionController::Base
  def show
    record_request
  ensure
    @server = Mqtt.mqtt_api_creds.hostname
    @port = Mqtt.mqtt_api_creds.port
    render inline: "***#{@server}:#{@port}***"
  end

  private

  def record_request
    gateway = Gateway.find_or_create_by(mac_address: params[:id])
    gateway.update!(version: params[:version], updated_at: Time.zone.now) if params[:version].present?
  end
end
