# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  let(:room) { FactoryBot.create :room_with_type }

  describe 'finds current temperature' do
    before do
      FactoryBot.create :reading, key: 'temperature', value: 20, room: room
      FactoryBot.create :reading, key: 'temperature', value: 15, room: room
      FactoryBot.create :reading, key: 'temperature', value: 21, room: room
    end

    it { expect(room.temperature).to eq(21) }
  end

  describe 'finds current humidity' do
    before do
      FactoryBot.create :humidity_reading, value: 100, room: room
      FactoryBot.create :humidity_reading, value: 65, room: room
      FactoryBot.create :humidity_reading, value: 71, room: room
    end

    it { expect(room.humidity).to eq(71) }
  end

  describe 'no readings' do
    it { expect(room.good?).to eq(false) }
    it { expect(room.current?('temperature')).to eq(false) }
    it { expect(room.current?('humidity')).to eq(false) }
    it { expect(room.age_of_last_reading('temperature')).to eq(nil) }
    it { expect(room.age_of_last_reading('humidity')).to eq(nil) }
  end

  describe 'has old reading' do
    before { FactoryBot.create :humidity_reading, value: 0, room: room, created_at: 3.hours.ago }

    it { expect(room.current?('temperature')).to eq(false) }
    it { expect(room.current?('humidity')).to eq(false) }
    it { expect(room.good?).to eq false }
    it { expect(room.enough_info_to_perform_rating?).to eq false }
    pending 'age_of_last_reading'
  end

  describe 'has current readings' do
    before do
      FactoryBot.create :humidity_reading, value: 65, room: room
      FactoryBot.create :temperature_reading, value: 21, room: room
    end

    it { expect(room.current?('humidity')).to eq(true) }
    it { expect(room.good?).to eq true }
    it { expect(room.enough_info_to_perform_rating?).to eq true }
  end

  describe 'age_of_last_reading' do
    before do
      Timecop.freeze
      FactoryBot.create :temperature_reading, created_at: 5.minutes.ago, room: room
    end

    after do
      Timecop.return
    end

    it { expect(room.age_of_last_reading('temperature')).to be_within(0.0001).of(5 * 60) }
  end

  describe 'room_type has min and max temperature set' do
    let(:room_type) { FactoryBot.create :room_type, min_temperature: 18.1, max_temperature: 25.9 }

    before do
      room.room_type = room_type
      room.save!
    end

    describe 'temp is too cold: 2.1' do
      before { FactoryBot.create :reading, key: 'temperature', value: 2.1, room: room }

      it { expect(room.good?).to eq(false) }
      it { expect(room.too_cold?).to eq(true) }
      it { expect(room.too_hot?).to eq(false) }
    end

    describe 'temp is good' do
      before { FactoryBot.create :reading, key: 'temperature', value: 19.2, room: room }

      it { expect(room.good?).to eq(true) }
      it { expect(room.too_cold?).to eq(false) }
      it { expect(room.too_hot?).to eq(false) }
    end

    describe 'temp is too hot:35' do
      before { FactoryBot.create :reading, key: 'temperature', value: 35, room: room }

      it { expect(room.good?).to eq(false) }
      it { expect(room.too_hot?).to eq(true) }
    end
  end
end
