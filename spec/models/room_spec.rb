require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryGirl.create :room }
  describe 'finds current temperature' do
    before do
      FactoryGirl.create :reading, key: 'temperature', value: 20, room: room
      FactoryGirl.create :reading, key: 'temperature', value: 15, room: room
      FactoryGirl.create :reading, key: 'temperature', value: 21, room: room
    end
    it { expect(room.temperature).to eq(21) }
  end
  describe 'finds current humidity' do
    before do
      FactoryGirl.create :reading, key: 'humidity', value: 100, room: room
      FactoryGirl.create :reading, key: 'humidity', value: 65, room: room
      FactoryGirl.create :reading, key: 'humidity', value: 71, room: room
    end
    it { expect(room.humidity).to eq(71) }
  end

  pending 'good?'
  describe 'current?' do
    describe 'no readings' do
      it { expect(room.current?('humidity')).to eq(false) }
    end
    describe 'has old reading' do
      before { FactoryGirl.create :reading, key: 'humidity', value: 0, room: room, created_at: 3.hours.ago }
      it { expect(room.current?('humidity')).to eq(false) }
    end
    describe 'has current readings' do
      before { FactoryGirl.create :reading, key: 'humidity', value: 0, room: room }
      it { expect(room.current?('humidity')).to eq(true) }
    end
  end
  pending 'age_of_last_reading'
  pending 'rating'
end
