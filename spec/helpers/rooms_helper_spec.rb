require 'rails_helper'

RSpec.describe RoomsHelper, type: :helper do
  describe 'display_temperature' do
    let(:room) { FactoryGirl.create(:temperature_reading, value: 20.6).room }
    it { expect(display_temperature(room)).to eq('20.6°C') }
  end

  describe 'display_humidity' do
    let(:room) { FactoryGirl.create(:humidity_reading, value: 100.2).room }
    it { expect(display_humidity(room)).to eq('100.2%') }
  end

  describe 'display_dewpoint' do
    let(:room) { FactoryGirl.create(:dewpoint_reading, value: 13.6).room }
    it { expect(display_dewpoint(room)).to eq('13.6°C') }
  end

  let(:cold_room) { FactoryGirl.create(:cold_room) }
  let(:ok_room) { FactoryGirl.create(:ok_room) }
  let(:hot_room) { FactoryGirl.create(:hot_room) }

  let(:healthy_room) { FactoryGirl.create(:healthy_room) }
  let(:damp_room) { FactoryGirl.create(:damp_room) }

  describe 'room_quality_level' do
    it { expect(room_quality_level(cold_room)).to eq('mid') }
    it { expect(room_quality_level(damp_room)).to eq('low') }
    it { expect(room_quality_level(ok_room)).to eq('high') }
    it { expect(room_quality_level(healthy_room)).to eq('high') }
  end

  describe 'temperature_quality' do
    it { expect(temperature_quality(cold_room)).to eq('temperature-low-2b') }
    it { expect(temperature_quality(damp_room)).to eq('temperature-mid-a') }
    it { expect(temperature_quality(ok_room)).to eq('temperature-mid-a') }
    it { expect(temperature_quality(hot_room)).to eq('temperature-high-1b') }
  end

  describe 'metric_quality' do
    it { expect(metric_quality(cold_room, 'humidity')).to eq('humidity-mid-a') }
    it { expect(metric_quality(ok_room, 'humidity')).to eq('humidity-mid-a') }
    it { expect(metric_quality(hot_room, 'humidity')).to eq('humidity-mid-a') }
    it { expect(metric_quality(healthy_room, 'humidity')).to eq('humidity-mid-a') }
    it { expect(metric_quality(damp_room, 'humidity')).to eq('humidity-high-2b') }
  end
end
