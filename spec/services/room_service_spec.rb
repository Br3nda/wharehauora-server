# frozen_string_literal: true

require('rails_helper')

RSpec.describe(RoomService, type: :model) do
  before { FactoryBot.create(:reading, key: 'dewpoint', value: room.calculate_dewpoint, room: room) }

  describe 'ratings' do
    subject { RoomService.ratings(room) }

    describe 'too hot' do
      let(:room)      { FactoryBot.create(:room, temperature: 38.1, humidity: 10.1, room_type: room_type) }
      let(:room_type) { FactoryBot.create(:room_type, min_temperature: 20, max_temperature: 25)           }

      it { is_expected.to(include(min_temperature: 20.0)) }
      it { is_expected.to(include(max_temperature: 25.0)) }

      it { is_expected.to(include(too_hot: true)) }
      it { is_expected.to(include(too_cold: false)) }
    end

    describe 'too cold' do
      let(:room) { FactoryBot.create(:room, temperature: 18.1, humidity: 10.1, room_type: room_type) }
      let(:room_type) { FactoryBot.create(:room_type, min_temperature: 26, max_temperature: 31) }

      it { is_expected.to(include(too_hot: false)) }
      it { is_expected.to(include(too_cold: true)) }
    end

    describe 'ok' do
      let(:room) { FactoryBot.create(:room, temperature: 25.1, humidity: 10.1, room_type: room_type) }
      let(:room_type) { FactoryBot.create(:room_type) }

      it { is_expected.to(include(too_damp: false)) }
    end

    describe 'too damp' do
      let(:room) { FactoryBot.create(:room, temperature: 1.1, humidity: 109.1, room_type: room_type) }
      let(:room_type) { FactoryBot.create(:room_type) }

      it { is_expected.to(include(too_damp: true)) }
    end
  end

  describe 'readings' do
    subject { RoomService.readings(room) }

    let(:room) { FactoryBot.create(:room, temperature: 1.1, humidity: 86.1, room_type: room_type) }
    let(:room_type) { FactoryBot.create(:room_type) }

    describe 'temperature' do
      it { expect(subject['temperature']).to(include(value: 1.1)) }
    end

    describe 'dewpoint' do
      it { expect(subject['dewpoint']).to(include(value: -1.0)) }
    end

    describe 'humidity' do
      it { expect(subject['humidity']).to(include(value: 86.1)) }
    end
  end
end
