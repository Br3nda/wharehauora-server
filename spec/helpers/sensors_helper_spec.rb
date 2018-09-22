# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SensorsHelper, type: :helper do
  # Freeze time
  before { Timecop.freeze(Time.local(2017)) }

  describe 'sensor_last_message' do
    subject { sensor_last_message(sensor) }

    describe 'No messages' do
      let(:sensor) { FactoryBot.create :sensor }

      it { is_expected.to eq '' }
    end

    describe 'some messages' do
      before { FactoryBot.create_list :message, 100, sensor: sensor, created_at: Time.local(2017, 0o1, 0o2) }

      let(:sensor) { FactoryBot.create :sensor }

      it { is_expected.to eq '1 day ago' }
    end
  end

  describe 'sensor_first_detected' do
    subject { sensor_first_detected(sensor) }

    let(:sensor) { FactoryBot.create :sensor }

    it { is_expected.to eq '2017-01-01' }
  end
end
