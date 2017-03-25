require 'rails_helper'

RSpec.describe ReadingsController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:home) { FactoryGirl.create :home, owner: user }
  let(:valid_params) { { home_id: home.id, key: 'temperature', day: '2017-01-01' } }
  context 'Not signed in' do
    describe 'GET index' do
      before { get :index, valid_params }
      it { expect(response).to have_http_status(:not_found) }
    end
  end

  context 'Signed in as home owner' do
    before { sign_in user }
    describe 'GET index' do
      before { get :index, valid_params }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
