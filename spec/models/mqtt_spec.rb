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
    let(:faraday_double) { double(Faraday, basic_auth: nil) }
    let(:response_double) do
      double('response_body',
             body: '[{"username": "hiria@hiria.nz", "password": "supersecretpassword"}]')
    end

    before { allow(Faraday).to receive(:new).and_return(faraday_double) }

    it 'fetch_mqtt_user_list' do
      expect(faraday_double).to receive(:get).and_return(response_double)
      expect(Mqtt.fetch_mqtt_user_list).to eq([{ 'username' => 'hiria@hiria.nz', 'password' => 'supersecretpassword' }])
    end

    it "sync_mqtt_users when user doesn't exist" do
      expect(faraday_double).to receive(:get).and_return(response_double)
      expect { Mqtt.sync_mqtt_users }.to change { MqttUser.count }.by(1)
    end
    it 'sync mqtt user when user does exit' do
      FactoryGirl.create :user, email: 'hiria@hiria.nz'
      expect(faraday_double).to receive(:get).and_return(response_double)
      expect { Mqtt.sync_mqtt_users }.to change { MqttUser.count }.by(1)
    end

    it 'provision_mqtt_user(username, password)' do
      expect(faraday_double).to receive(:post).and_return ''
      Mqtt.provision_mqtt_user('bob', 'bob')
    end
  end
end
