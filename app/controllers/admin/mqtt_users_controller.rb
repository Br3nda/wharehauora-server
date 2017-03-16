require 'requests/sugar'

class Admin::MqttUsersController < ApplicationController
  def index
    authorize :mqtt_user
    sync_mqtt_user
    @mqtt_users = MqttUser.all.page(params[:page])
  end

  private

  def url
    'https://api.cloudmqtt.com'
  end

  def sync_mqtt_user
    fetch_mqtt_user_list.each do |record|
      user = User.find_by(email: record['username'])

      # make a record of this mqtt user
      mqtt_user = MqttUser.find_by(username: record['username'])
      mqtt_user = MqttUser.new(username: record['username']) unless mqtt_user

      # link to our own user record
      mqtt_user.user = user if user
      mqtt_user.save!
    end
  end

  def fetch_mqtt_user_list
    mqtt_admin_credentials = ENV['CLOUDMQTT_URL']
    uri = URI.parse(mqtt_admin_credentials)
    response = Requests.get("#{url}/user", auth: [uri.user, uri.password])
    response.json
  end
end
