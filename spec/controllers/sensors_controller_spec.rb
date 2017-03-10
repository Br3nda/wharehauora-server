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
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'GET show' do
      before { get :show, id: sensor.id }
      it { expect(response).to have_http_status(:success) }
    end

    describe '#update' do
      before { patch :update, id: sensor.to_param, sensor: { room_name: 'Living room' } }
      it { expect(response).to redirect_to home_sensors_path(home) }
    end
  end

  context "Trying to access another users's data" do
    before { sign_in user }
    describe "GET edit for someone else's home" do
      let(:another_user) { FactoryGirl.create(:user) }
      let(:another_home) { FactoryGirl.create(:home, owner_id: another_user.id) }
      let(:another_sensor) { FactoryGirl.create(:sensor, home_id: another_home.id) }

      describe '#show' do
        before { get :show, id: another_sensor.to_param }
        it { expect(response).to have_http_status(:not_found) }
      end
      describe '#edit' do
        before { get :show, id: another_sensor.to_param }
        it { expect(response).to have_http_status(:not_found) }
      end
    end
  end
end
