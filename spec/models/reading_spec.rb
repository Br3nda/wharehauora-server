require 'rails_helper'

RSpec.describe Reading, type: :model do
  let(:home_type) { FactoryGirl.create :home_type, name: 'Whare' }
  let(:room_type) { FactoryGirl.create :room_type, name: 'Ruma' }
  let(:home) { FactoryGirl.create :home, home_type: home_type }
  let(:room) { FactoryGirl.create :room, home: home, room_type: room_type }

  describe 'medians' do
    before do
      10.times do
        FactoryGirl.create :reading, room: room, key: 'temperature', value: 20
        FactoryGirl.create :reading, room: room, key: 'happiness', value: 100
        FactoryGirl.create :reading, room: room, key: 'temperature', value: 15
      end
      FactoryGirl.create :reading, room: room, key: 'temperature', value: 15
    end

    it 'calculates the median temperature' do
      expect(Reading.temperature.median(:value)).to eq(15)

      FactoryGirl.create :reading, room: room, key: 'temperature', value: 1000
      FactoryGirl.create :reading, room: room, key: 'temperature', value: 5000

      expect(Reading.temperature.median(:value)).to eq(20.0)
    end
  end

  describe 'data relationships' do
    let!(:reading) { FactoryGirl.create :reading, room: room, key: 'temperature', value: 99 }
    let!(:mould_reading) { FactoryGirl.create :reading, room: room, key: 'mould', value: 99 }
    let!(:humidity_reading) { FactoryGirl.create :reading, room: room, key: 'humidity', value: 99 }
    it 'belongs to a room' do
      expect(reading.room).to eq(room)
      expect(room.readings.first).to eq(reading)
    end
    it 'belongs to a home' do
      expect(reading.home).to eq(home)
    end

    before do
      10.times do
        FactoryGirl.create :reading, key: 'test'
      end
    end
    it 'finds temperature' do
      expect(Reading.temperature.first).to eq(reading)
    end
    it 'finds mould' do
      expect(Reading.mould.first).to eq(mould_reading)
    end
    it 'finds humidity' do
      expect(Reading.humidity.first).to eq(humidity_reading)
    end
  end

  describe 'data validation' do
    it 'requires a key' do
      expect { Reading.create!(room: room, value: 1) }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'requires a value' do
      expect { Reading.create!(room: room, key: 'test') }.to raise_error(ActiveRecord::RecordInvalid)
    end
    it 'requires a room' do
      expect { Reading.create!(value: 1, key: 'test') }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
