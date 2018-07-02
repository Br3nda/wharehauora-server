require 'rails_helper'

RSpec.describe Home, type: :model do
  describe "gateway_mac_address is unique" do
    it do
      home = FactoryBot.create :home, gateway_mac_address: 'abc'
      expect do
        FactoryBot.create :home, gateway_mac_address: 'abc'
      end.to raise_error ActiveRecord::RecordInvalid
    end
  end
end
