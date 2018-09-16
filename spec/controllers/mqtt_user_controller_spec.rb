# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MqttUserController, type: :controller do
  let(:home)    { FactoryBot.create :home, gateway_mac_address: gateway.mac_address }
  let(:gateway) { FactoryBot.create :gateway, mac_address: '123'                    }

  before { sign_in home.owner }

  describe 'GET index' do
    before { get :index, params: { home_id: home.id } }

    it { expect(assigns(:home)).to eq home }
    it { expect(assigns(:gateway)).to eq gateway }
    it { expect(gateway.mac_address).to eq home.gateway_mac_address }
  end
end
