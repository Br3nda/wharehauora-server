# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Reading, type: :model do
  let(:home_type) { FactoryBot.create :home_type, name: 'Whare'               }
  let(:room_type) { FactoryBot.create :room_type, name: 'Ruma'                }
  let(:home)      { FactoryBot.create :home, home_type: home_type             }
  let(:room)      { FactoryBot.create :room, home: home, room_type: room_type }

  describe 'medians' do
    before do
      10.times do
        FactoryBot.create :reading, room: room, key: 'temperature', value: 20
        FactoryBot.create :reading, room: room, key: 'happiness', value: 100
        FactoryBot.create :reading, room: room, key: 'temperature', value: 15
      end
      FactoryBot.create :reading, room: room, key: 'temperature', value: 15
    end

    it 'calculates the median temperature' do
      expect(Reading.temperature.median(:value)).to eq(15)

      FactoryBot.create :reading, room: room, key: 'temperature', value: 1000
      FactoryBot.create :reading, room: room, key: 'temperature', value: 5000

      expect(Reading.temperature.median(:value)).to eq(20.0)
    end
  end

  describe 'data relationships' do
    let!(:reading) { FactoryBot.create :reading, room: room, key: 'temperature', value: 99 }
    let!(:mould_reading)    { FactoryBot.create :reading, room: room, key: 'mould', value: 99    }
    let!(:humidity_reading) { FactoryBot.create :reading, room: room, key: 'humidity', value: 99 }

    before do
      FactoryBot.create_list :reading, 10, key: 'test'
    end

    it 'belongs to a room' do
      expect(reading.room).to eq(room)
      expect(room.readings.first).to eq(reading)
    end
    it 'belongs to a home' do
      expect(reading.home).to eq(home)
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
