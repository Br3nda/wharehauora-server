require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  let(:user) { FactoryGirl.create :user }
  let(:home) { FactoryGirl.create :home, owner: user }
  let(:sensor) { FactoryGirl.create :sensor, home: home, node_id: 1 }
  let(:valid_params) { { sensor_id: sensor.id } }
  context 'Not signed in' do
    describe 'GET index' do
      before { get :index, valid_params }
      it { expect(response).to redirect_to(root_path) }
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
