require 'rails_helper'

RSpec.describe Mqtt, type: :model do
  pending 'fetch_mqtt_user_list'
  pending 'sync_mqtt_users'
  pending 'provision_mqtt_user(username, password)'
  pending 'url'
  pending 'mqtt_api_creds'
  it 'makes a faraday_conn' do
    expect(Mqtt.faraday_conn).to be_a(Faraday::Connection)
  end
end
