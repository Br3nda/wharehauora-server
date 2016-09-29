require 'rails_helper'

RSpec.describe Sensor, type: :model do
  let(:sensor) { FactoryGirl.create(:sensor) }
  context "no readings yet" do
    it { expect(sensor.temperature).to eq(nil) }
  end
  context "readings have no values" do
    before { FactoryGirl.create(:reading, sensor: sensor, value: nil, sub_type: MySensors::SetReq::V_TEMP) }
    it { expect(sensor.temperature).to eq(nil) }
  end
  context "lots of readings" do
    before do
      500.times { FactoryGirl.create(:reading, sensor: sensor, value: 100, sub_type: MySensors::SetReq::V_TEMP) }
      FactoryGirl.create(:reading, sensor: sensor, value: 10, sub_type: MySensors::SetReq::V_TEMP)
    end
    it { expect(sensor.temperature).to eq(10) }
  end
end
