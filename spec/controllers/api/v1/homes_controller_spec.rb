require 'rails_helper'

RSpec.describe Api::V1::HomesController, type: :controller do
  let(:my_home) { FactoryGirl.create(:home, owner: user) }
  let(:public_home) { FactoryGirl.create(:home, owner: user) }
  let(:private_home) { FactoryGirl.create(:home) }

  let!(:user) { FactoryGirl.create :user }

  context 'OAuth authenticated ' do
    let!(:application) { FactoryGirl.create(:oauth_application) }
    subject { JSON.parse response.body }

    describe 'GET #index' do
      shared_examples 'token belongs to home owner' do
        let!(:token) do
          FactoryGirl.create(:oauth_access_token,
                             application: application,
                             resource_owner_id: my_home.owner.id)
        end
      end

      shared_examples 'response includes my home' do
        it { is_expected.to eq('hello') }
        it { expect(subject['data']['homes']).to eq(id: my_home.id, name: my_home.name) }
        it { expect(my_home.owner.id).to eq(token.resource_owner_id) }
        it { expect(user.owned_homes).to include(my_home) }
      end
      shared_examples 'response includes public homes' do
      end
      shared_examples 'response does not includes private homes' do
      end

      describe 'home owner' do
        include_examples 'token belongs to home owner'
        before { get :index, format: :json, access_token: token.token }
        it { expect(response.status).to eq 200 }
        include_examples 'response includes my home'
        include_examples 'response includes public homes'
        include_examples 'response does not includes private homes'
      end

      # context 'invalid access token' do
      #   before { get :index, format: :json }
      #   include_examples 'response includes public homes'
      #   include_examples 'response does not includes private homes'
      # end
    end
  end
end
