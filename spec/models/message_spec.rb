# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  let(:home) { FactoryBot.create :home, gateway_mac_address: '123A456B789' }

  describe 'decode' do
    subject { Message.new.decode(topic, payload) }

    let(:payload) { '20.9' }

    context 'no sensor exists yet' do
      shared_examples 'decodes message' do
        it { expect { subject }.to change(Message, :count).by(1) }
        it { expect { subject }.to change(Reading, :count).by(1) }
        it { expect { subject }.to change(Sensor, :count).by(1) }
        it { expect { subject }.to change(Room, :count).by(1) }
        it { expect(subject.sensor.home).to eq(home) }
      end

      context 'v1' do
        let(:topic) { "/sensors/wharehauora/#{home.id}/120/1/1/0/0" }

        include_examples 'decodes message'
        it { expect(subject.version).to eq 'wharehauora' }
        it { expect(subject.sensor.node_id).to eq 120 }
      end

      context 'v2' do
        let(:topic) { "/sensors/v2/#{home.gateway_mac_address}/ABC123/1/1/0/0" }

        include_examples 'decodes message'
        it { expect(subject.version).to eq 'v2' }
        it { expect(subject.sensor.mac_address).to eq 'ABC123' }
      end
    end

    context 'when sensor is allocated to a room' do
      let(:room)    { FactoryBot.create :room, home: home                               }
      let!(:sensor) { FactoryBot.create :sensor, home: home, room: room, node_id: '130' }

      shared_examples 'decodes messages' do
        it 'does not make a new sensor record' do
          expect { subject }.not_to(change(Sensor, :count))
        end

        it 'saves a reading' do
          expect { subject }.to change(Reading, :count).by(1)
        end

        it 'saves against the correct sensor' do
          message = Message.new.decode(topic, payload)
          expect(message.sensor).to eq(sensor)
          expect(message.node_id).to eq(130)
        end
        it 'Saves a reading' do
          Message.new.decode(topic, payload)
          expect(Reading.last.value).to eq(20.9)
          expect(Reading.last.room.home).to eq(home)
        end
      end

      context 'v1' do
        let!(:topic) { "/sensors/wharehauora/#{home.id}/#{sensor.node_id}/1/1/0/0" }

        include_examples 'decodes messages'
      end

      context 'v2' do
        let(:topic) { "/sensors/v2/#{home.gateway_mac_address}/#{sensor.mac_address}/1/1/0/0" }

        include_examples 'decodes messages'
      end
    end
  end
end
