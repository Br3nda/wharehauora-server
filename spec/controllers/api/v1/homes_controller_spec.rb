require 'rails_helper'

RSpec.describe Api::V1::HomesController, type: :controller do
  let!(:my_home) { FactoryBot.create(:home, owner: user) }
  let!(:public_home) { FactoryBot.create(:public_home) }
  let!(:private_home) { FactoryBot.create(:home) }

  let!(:user) { FactoryBot.create :user }

  context 'OAuth authenticated ' do
    let!(:application) { FactoryBot.create(:oauth_application) }
    subject { JSON.parse response.body }

    describe 'GET #index' do
      shared_examples 'token belongs to home owner' do
        let!(:token) do
          FactoryBot.create(:oauth_access_token,
                            application: application,
                            resource_owner_id: my_home.owner.id)
        end
        it { expect(my_home.owner.id).to eq(token.resource_owner_id) }
        it { expect(user.owned_homes).to include(my_home) }
      end

      shared_examples 'response includes my home' do
        describe 'response includes my home' do
          let(:matching_home) { subject['data'].select { |home| home['id'] == my_home.id.to_s }.first }
          it { expect(matching_home).to include('id' => my_home.id.to_s) }
          it { expect(matching_home['attributes']).to include('name' => my_home.name) }
        end
      end
      shared_examples 'response includes public homes' do
        describe 'response includes public home' do
          let(:matching_home) { subject['data'].select { |home| home['id'] == public_home.id.to_s }.first }
          it { expect(matching_home).to include('id' => public_home.id.to_s) }
          it { expect(matching_home['attributes']).to include('name' => public_home.name) }
        end
      end
      shared_examples 'response does not includes private homes' do
        describe 'response does not include private homes' do
          it { expect(subject['data'].any? { |home| home['id'] == private_home.id.to_s }).to eq(false) }
        end
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
