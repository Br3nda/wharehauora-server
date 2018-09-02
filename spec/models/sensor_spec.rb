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

  describe 'on creation' do
    it { expect(FactoryBot.create(:sensor, room_id: nil).room_id).not_to be nil }
    it { expect(FactoryBot.create(:unassigned_sensor, room_id: nil).room_id).to eq nil }
    describe 'with no room associated' do
      it 'sets a name' do
        expect(FactoryBot.create(:sensor, room_id: nil).room.name).not_to be nil
      end
      it { expect { FactoryBot.create(:sensor, room_id: nil) }.to change(Room, :count).by(1) }
    end

    describe 'with an associated room' do
      let!(:room) { FactoryBot.create(:room) }

      it { expect { FactoryBot.create(:sensor, room: room) }.not_to change(Room, :count) }
    end
  end
end
