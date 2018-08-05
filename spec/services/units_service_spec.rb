# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UnitsService, type: :model do
  describe '#unit_for' do
    it { expect(UnitsService.unit_for('temperature')).to eq '°C' }
    it { expect(UnitsService.unit_for('dewpoint')).to eq '°C' }
    it { expect(UnitsService.unit_for('humidity')).to eq '%' }
    it { expect(UnitsService.unit_for('nothing')).to eq '?' }
  end
end
