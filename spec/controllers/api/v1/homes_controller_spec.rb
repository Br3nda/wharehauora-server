require 'rails_helper'

RSpec.describe Api::V1::HomesController, type: :controller do
  context 'OAuth authenticated ' do
    let!(:application) { FactoryGirl.create(:oauth_application) }
    let!(:home)        { FactoryGirl.create(:home, owner: user) }
    let!(:user) { FactoryGirl.create :user }

    describe 'GET #index' do
      shared_examples 'token belongs to home owner' do
        let!(:token) do
          FactoryGirl.create(:oauth_access_token,
                             application: application,
                             resource_owner_id: home.owner.id)
        end
        it { expect(home.owner.id).to eq(token.resource_owner_id) }
        it { expect(user.owned_homes).to include(home) }
      end
      shared_examples 'response includes home'

      describe 'home owner' do
        include_examples 'token belongs to home owner'
        before { get :index, format: :json, access_token: token.token }
        it { expect(response.status).to eq 200 }
        it { expect(response.body['data']['homes']).to eq(id: home.id, name: home.name) }
      end

      context 'invalid access token' do
        before { get :index, format: :json }
        it { expect(response.status).to eq 401 }
      end
    end
  end
end
