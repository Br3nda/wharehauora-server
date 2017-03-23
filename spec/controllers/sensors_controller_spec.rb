require 'rails_helper'
RSpec.describe SensorsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:bedroom) { FactoryGirl.create(:room_type, name: 'bedroom') }

  let(:user) { FactoryGirl.create(:user) }
  let(:home) { FactoryGirl.create(:home, owner_id: user.id) }
  let(:room) { FactoryGirl.create(:room, home: home, room_type: bedroom) }
  let(:sensor) { FactoryGirl.create(:sensor, room: room, node_id: '1100') }

  context 'Not signed in' do
    describe 'GET show' do
      before { get :show, id: sensor.id }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
    describe 'delete' do
      before { delete :destroy, id: sensor.id }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'GET index' do
      before { get :index, home_id: home.id }
      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:sensors)).to eq([sensor]) }
      it { expect(assigns(:home)).to eq(home) }
    end

    describe 'GET show' do
      before { get :show, home_id: home.id, id: sensor.id }
      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:sensor)).to eq(sensor) }
    end

    describe 'delete' do
      before { delete :destroy, id: sensor.id }
      it { expect(response).to redirect_to(home_sensors_path(sensor.home)) }
    end
  end
end
