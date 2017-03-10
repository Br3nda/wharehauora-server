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
      before { get :show, home_id: home.id, id: sensor.id }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
