# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sensor, type: :model do
  describe 'sensor mac address is unique' do
    it do
      FactoryBot.create :sensor, mac_address: 'xyz'
      expect do
        FactoryBot.create :sensor, mac_address: 'xyz'
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
