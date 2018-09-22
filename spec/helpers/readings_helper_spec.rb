# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReadingsHelper, type: :helper do
  subject { display_reading(reading) }

  describe 'temperatures' do
    describe 'factional numbers' do
      let(:reading) { FactoryBot.create :temperature_reading, value: 10.5 }

      it { is_expected.to eq '10.5°C' }
    end

    describe 'round numbers' do
      let(:reading) { FactoryBot.create :temperature_reading, value: 10 }

      it { is_expected.to eq '10.0°C' }
    end

    describe 'large numbers' do
      let(:reading) { FactoryBot.create :temperature_reading, value: 1000 }

      it { is_expected.to eq '1000.0°C' }
    end
  end

  describe 'humidity' do
    describe 'factional numbers' do
      let(:reading) { FactoryBot.create :humidity_reading, value: 10.5 }

      it { is_expected.to eq '10.5%' }
    end

    describe 'round numbers' do
      let(:reading) { FactoryBot.create :humidity_reading, value: 10 }

      it { is_expected.to eq '10.0%' }
    end

    describe 'large numbers' do
      let(:reading) { FactoryBot.create :humidity_reading, value: 1000 }

      it { is_expected.to eq '1000.0%' }
    end
  end
end
