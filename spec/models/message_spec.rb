require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'decode' do
    let(:home) { FactoryGirl.create :home }
    let(:payload) { '20.9' }

    context 'No rooms associated with sensor' do
      let(:topic) { "/sensors/wharehauora/#{home.id}/102/1/1/0/0" }
      it 'Saves message' do
        expect do
          Message.decode(topic, payload)
        end.to change { Message.count }.by(1)
      end

      it 'Saves sensor' do
        expect do
          Message.decode(topic, payload)
        end.to change { Sensor.count }.by(1)
      end

      it 'Does not save a reading' do
        expect do
          Message.decode(topic, payload)
        end.not_to(change { Reading.count })
      end

      it 'Saves to the correct home' do
        message = Message.decode(topic, payload)
        expect(message.sensor.home).to eq(home)
      end
    end
    context 'when sensor is allocated to a room' do
      let!(:topic) { "/sensors/wharehauora/#{home.id}/#{sensor.node_id}/1/1/0/0" }
      let(:room) { FactoryGirl.create :room, home: home }
      let(:sensor) { FactoryGirl.create :sensor, home: home, room: room, node_id: '130' }

      it 'does not make a new sensor record' do
        expect { Message.decode(topic, payload) }.not_to(change { Sensor.count })
      end

      it 'saves a reading' do
        expect { Message.decode(topic, payload) }.to change { Reading.count }.by(1)
      end

      it 'saves against the correct sensor' do
        message = Message.decode(topic, payload)
        expect(message.sensor).to eq(sensor)
        expect(message.node_id).to eq(130)
      end
      it 'Saves a reading' do
        Message.decode(topic, payload)
        expect(Reading.last.value).to eq(20.9)
        expect(Reading.last.room.home).to eq(home)
      end
    end
  end
end
