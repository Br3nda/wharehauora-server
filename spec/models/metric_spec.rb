require 'rails_helper'

RSpec.describe Metric, type: :model do
  describe 'metrics_by_home_and_room' do
    let(:home_type) { FactoryGirl.create :home_type, name: 'Whare' }
    let(:room_type) { FactoryGirl.create :room_type, name: 'Ruma' }
    let(:home) { FactoryGirl.create :home, home_type: home_type }
    let(:room) { FactoryGirl.create :room, home: home, room_type: room_type }
    before do
      10.times do
        FactoryGirl.create :metric, room: room, key: 'temperature', value: 20
      end
      11.times do
        FactoryGirl.create :metric, room: room, key: 'temperature', value: 15
      end
    end
    it do
      expected_data = { [home_type.id, room_type.id] => 15 }
      data = Metric.metrics_by_home_and_room(3.hours.ago).temperature.median(:value)
      expect(data).to eq(expected_data)

      FactoryGirl.create :metric, room: room, key: 'temperature', value: 1000
      FactoryGirl.create :metric, room: room, key: 'temperature', value: 5000
      expected_data = { [home_type.id, room_type.id] => 20.0 }
      data = Metric.metrics_by_home_and_room(3.hours.ago).temperature.median(:value)
      expect(data).to eq(expected_data)
    end
  end
end
