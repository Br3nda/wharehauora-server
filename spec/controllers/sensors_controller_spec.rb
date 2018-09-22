# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SensorsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:bedroom) { FactoryBot.create(:room_type, name: 'bedroom') }

  let(:user) { FactoryBot.create(:user) }
  let(:home)   { FactoryBot.create(:home, owner_id: user.id)                         }
  let(:room)   { FactoryBot.create(:room, home: home, room_type: bedroom)            }
  let(:sensor) { FactoryBot.create(:sensor, home: home, room: room, node_id: '1100') }

  context 'Not signed in' do
    describe 'GET show' do
      before { get :show, params: { id: sensor.id } }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  context 'user is signed in' do
    before { sign_in user }

    describe 'GET show' do
      before { get :show, params: { home_id: home.id, id: sensor.id } }

      it { expect(response).to have_http_status(:success) }
      it { expect(assigns(:sensor)).to eq(sensor) }
    end
  end
end
