# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::MqttUsersController, type: :controller do
  include Devise::Test
  let(:home)       { FactoryBot.create(:home)                  }
  let(:mqtt_user)  { FactoryBot.create(:mqtt_user, home: home) }
  let(:admin_user) { FactoryBot.create(:admin)                 }

  let(:valid_params) { { name: Faker.name } }
  let(:faraday_double) { double(Faraday, basic_auth: nil, post: '') }

  before do
    ENV['CLOUDMQTT_URL'] = 'mqtt://bob:bobpassword@qwerty.mqttsomewhere.nz:12345/hey'
    allow(Faraday).to receive(:new).and_return faraday_double
  end

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(new_user_session_path) }
    end

    describe 'PUT create' do
      before { put :create }

      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  context 'signed in as home owner' do
    before { sign_in home.owner }

    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(root_path) }
    end

    describe 'POST create,' do
      before { post :create, params: { home_id: home.id } }

      it { expect(response).to redirect_to(root_path) }
    end
  end

  context 'signed in as whanau' do
    before do
      user = FactoryBot.create :user
      home.users << user
      sign_in user
    end

    describe 'GET index' do
      before { get :index }

      it { expect(response).to redirect_to(root_path) }
    end

    describe 'POST create,' do
      before { post :create, params: { home_id: home.id } }

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
      before { post :create, params: { home_id: home.id } }

      it { expect(response).to redirect_to(admin_mqtt_users_path) }
    end
  end
end
