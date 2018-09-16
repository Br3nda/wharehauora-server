# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'OAuth Authorization', type: :request do
  let(:oauth_application)  { FactoryBot.create(:oauth_application) }
  let(:user)               { FactoryBot.create(:user)              }
  let(:authorize_response) { JSON.parse(response.body)             }

  before { post '/oauth/token', params: auth_creds }

  describe 'auth ok' do
    let(:auth_creds) do
      { username: user.email, password: user.password, client_id: oauth_application.uid, grant_type: 'password', format: :json }
    end

    it { expect(response.status).to eq 200 }
    it { expect(authorize_response['access_token']).to be_present }
    it { expect(authorize_response['refresh_token']).to be_present }
  end

  describe 'auth not ok' do
    let(:auth_creds) do
      { username: user.email, password: '123', client_id: oauth_application.uid, grant_type: 'password', format: :json }
    end

    it { expect(response.status).to eq 401 }
    it { expect(authorize_response['error']).to eq 'Invalid Email or password.' }
  end
end
