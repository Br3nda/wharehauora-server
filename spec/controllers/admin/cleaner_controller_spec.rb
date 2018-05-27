require 'rails_helper'

RSpec.describe Admin::CleanerController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:admin_role) { FactoryBot.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryBot.create(:user, roles: [admin_role]) }
  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
    describe 'delete rooms' do
      before { delete :rooms }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
    describe 'delete sensors' do
      before { delete :sensors }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end
  context 'signed in as normal user' do
    before { sign_in user }
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(root_path) }
    end
    describe 'delete rooms' do
      before { delete :rooms }
      it { expect(response).to redirect_to(root_path) }
    end
    describe 'delete sensors' do
      before { delete :sensors }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  context 'signed in as admin' do
    before { sign_in admin_user }
    describe 'GET index' do
      before { get :index }
      it { expect(response).to have_http_status(:success) }
    end

    describe 'delete rooms' do
      before { FactoryBot.create :room }
      it { expect { delete :rooms }.to change { Room.count }.by(-1) }
    end

    describe 'delete sensors' do
      before { FactoryBot.create :sensor, node_id: 1 }
      it { expect { delete :sensors }.to change { Sensor.count }.by(-1) }
    end
  end
end
