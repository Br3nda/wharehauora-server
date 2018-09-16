# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Gateway::ConfigController, type: :controller do
  describe 'GET config for a gateway' do
    before do
      ENV['CLOUDMQTT_URL'] = 'mqtt://bob:bobpassword@qwerty.mqttsomewhere.nz:12345/hey'
      post :show, params: { id: 'abc', version: 'hello', format: :text }
    end

    it { expect(response).to have_http_status(:success) }
    it { expect(response.body).to eq('***qwerty.mqttsomewhere.nz:12345***') }
    it { expect(response.content_type).to eq 'text/plain' }
    it { expect(Gateway.last.version).to eq 'hello' }
    it { expect(Gateway.last.mac_address).to eq 'abc' }
  end

  it do
    expect do
      post :show, params: { id: 'abc', version: 'hello', format: :text }
    end.to change(Gateway, :count).by(1)
  end
end
