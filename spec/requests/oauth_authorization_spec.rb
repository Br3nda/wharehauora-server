# frozen_string_literal: true

require('rails_helper')

RSpec.describe('OAuth Authorization', type: :request) do
  let(:oauth_application) { FactoryBot.create(:oauth_application) }
  let(:user)              { FactoryBot.create(:user)              }

  it 'auth ok' do
    post '/oauth/token',
         { username: user.email, password: user.password, client_id: oauth_application.uid, grant_type: 'password' },
         :Accept => 'application/json'

    expect(response.status).to(eq(200))
    authorize_response = JSON.parse(response.body)
    expect(authorize_response['access_token']).to(be_present)
    expect(authorize_response['refresh_token']).to(be_present)
  end

  it 'auth not ok' do
    post '/oauth/token',
         { username: user.email, password: '123', client_id: oauth_application.uid, grant_type: 'password' },
         :Accept => 'application/json'

    expect(response.status).to(eq(401))
    authorize_response = JSON.parse(response.body)
    expect(authorize_response['error']).to(eq('Invalid Email or password.'))
  end
end
