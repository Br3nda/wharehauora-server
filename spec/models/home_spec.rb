require 'rails_helper'

RSpec.describe Home, type: :model do
  describe 'gateway_mac_address is unique' do
    it do
      FactoryBot.create :home, gateway_mac_address: 'abc'
      expect do
        FactoryBot.create :home, gateway_mac_address: 'abc'
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
  describe 'provisions user' do
    let(:home) { FactoryBot.create :home, gateway_mac_address: 'abc' }
    before do
      ENV['SALT'] = 'hello'
      home.provision_mqtt!
    end
    it { expect(home.mqtt_user.username).to eq home.gateway_mac_address }
    it { expect(home.mqtt_user.password).to eq 'd76051e1dae76d1f309598102df58d84' }
  end
end
