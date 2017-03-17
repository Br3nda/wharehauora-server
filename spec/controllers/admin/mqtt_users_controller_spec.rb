require 'rails_helper'

RSpec.describe Admin::MqttUsersController, type: :controller do
  include Devise::Test
  let(:user) { FactoryGirl.create(:user) }
  let(:mqtt_user) { FactoryGirl.create(:mqtt_user, user: user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  let(:valid_params) { { name: Faker.name } }
  let(:faraday_double) { double(Faraday, basic_auth: nil, post: '') }
  before do
    allow(Faraday).to receive(:new).and_return faraday_double
  end

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(root_path) }
    end
    describe 'PUT create' do
      before { put :create }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  context 'signed in as normal user' do
    before { sign_in user }
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(root_path) }
    end
    describe 'POST create,' do
      before { post :create, user_id: user.id }
      it { expect(response).to redirect_to(root_path) }
    end
  end

  context 'signed in as admin' do
    before { sign_in admin_user }
    describe 'GET index' do
      before { get :index }
      it { expect(response).to have_http_status(:success) }
    end
    describe 'POST create,' do
      before { post :create, user_id: user.id }
      it { expect(response).to redirect_to(admin_mqtt_users_path) }
    end
  end
end
