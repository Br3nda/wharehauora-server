# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user)      { FactoryBot.create(:user) }
  let(:home_type) { FactoryBot.create(:home_type) }
  let(:home)      { FactoryBot.create(:home, home_type: home_type) }
  let(:room)      { FactoryBot.create(:room, home: home) }

  context 'user is not sign in' do
    describe 'GET index' do
      context 'no sensor data' do
        before { get :index }

        it { expect(response).to have_http_status(:success) }
      end

      context 'lots of sensor data' do
        let!(:readings) do
          [
            FactoryBot.create(:reading, room: room),
            FactoryBot.create(:reading, room: room),
            FactoryBot.create(:reading, room: room),
            FactoryBot.create(:reading, room: room),
            FactoryBot.create(:reading, room: room)
          ]
        end

        before { get :index }

        it { expect(response).to have_http_status(:success) }
      end
    end
  end

  context 'user is signed in' do
    before do
      sign_in user
    end

    describe 'GET index' do
      before { get :index }

      it { expect(response).to have_http_status(:success) }
    end
  end
end
