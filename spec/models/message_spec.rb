require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'decode' do
    let(:home) { FactoryGirl.create :home }
    it do
      topic = "/sensors/wharehauora/#{home.id}/102/1/1/0/0"
      payload = '20.9'
      message = Message.decode(topic, payload)
      expect(message.sensor.room.home).to eq(home)
      expect(Reading.last.value).to eq(20.9)
      expect(Reading.last.room.home).to eq(home)
    end
  end
end
