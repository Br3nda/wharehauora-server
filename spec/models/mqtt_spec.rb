require 'rails_helper'

RSpec.describe Mqtt, type: :model do
  before { ENV['CLOUDMQTT_URL'] = 'mqtt://bob:bobpassword@qwerty.mqttsomewhere.nz:12345/hey' }
  it 'makes a faraday_conn' do
    expect(Mqtt.faraday_conn).to be_a(Faraday::Connection)
  end
  it 'Parses cloud mqtt credentials' do
    expect(Mqtt.mqtt_api_creds.user).to eq('bob')
    expect(Mqtt.mqtt_api_creds.password).to eq('bobpassword')
  end
  it { expect(Mqtt.url).to eq('https://api.cloudmqtt.com') }

  context 'With faraday_double' do
    let(:faraday_double) do
      double(Faraday,
             post: '',
             basic_auth: nil,
             get: response_double)
    end
    let(:response_double) do
      double('response_body',
             body: '[{"username": "hiria", "password": "supersecretpassword"}]')
    end
    before do
      allow(Faraday).to receive(:new).and_return(faraday_double)
    end

    it 'fetch_mqtt_user_list' do
      expect(Mqtt.fetch_mqtt_user_list).to eq([{ 'username' => 'hiria', 'password' => 'supersecretpassword' }])
    end

    pending 'sync_mqtt_users'

    it 'provision_mqtt_user(username, password)'
  end
end
