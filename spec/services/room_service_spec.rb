require 'rails_helper'

RSpec.describe RoomService, type: :model do
  describe 'ratings' do
    before do
      FactoryGirl.create :reading, key: 'dewpoint', value: room.calculate_dewpoint, room: room
    end

    subject { RoomService.ratings(room) }

    describe 'too hot' do
      let(:room) { FactoryGirl.create :room, temperature: 38.1, humidity: 10.1, room_type: room_type }
      let(:room_type) { FactoryGirl.create :room_type, min_temperature: 20, max_temperature: 25 }

      it { is_expected.to include(min_temperature: 20.0) }
      it { is_expected.to include(max_temperature: 25.0) }

      it { is_expected.to include(too_hot: true) }
      it { is_expected.to include(too_cold: false) }
    end

    describe 'too cold' do
      let(:room) { FactoryGirl.create :room, temperature: 18.1, humidity: 10.1, room_type: room_type }
      let(:room_type) { FactoryGirl.create :room_type, min_temperature: 26, max_temperature: 31 }
      it { is_expected.to include(too_hot: false) }
      it { is_expected.to include(too_cold: true) }
    end

    describe 'ok' do
      let(:room) { FactoryGirl.create :room, temperature: 25.1, humidity: 10.1, room_type: room_type }
      let(:room_type) { FactoryGirl.create :room_type }
      it { is_expected.to include(too_damp: false) }
    end

    describe 'too damp' do
      let(:room) { FactoryGirl.create :room, temperature: 1.1, humidity: 109.1, room_type: room_type }
      let(:room_type) { FactoryGirl.create :room_type }
      it { is_expected.to include(too_damp: true) }
    end
  end
  describe 'readings' do
    subject { RoomService.readings(room) }
  end
end
