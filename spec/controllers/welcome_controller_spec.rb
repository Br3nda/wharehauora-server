require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }
  let(:home_type) { FactoryGirl.create(:home_type) }
  let(:home) { FactoryGirl.create(:home, home_type: home_type) }
  let(:sensor) { FactoryGirl.create(:sensor, home: home) }
  context 'user is not sign in' do
    describe 'GET index' do
      context 'no sensor data' do
        before { get :index }
        it { expect(response).to have_http_status(:success) }
      end
      context 'lots of sensor data' do
        let!(:readings) do
          [
            FactoryGirl.create(:reading, sensor: sensor),
            FactoryGirl.create(:reading, sensor: sensor),
            FactoryGirl.create(:reading, sensor: sensor),
            FactoryGirl.create(:reading, sensor: sensor),
            FactoryGirl.create(:reading, sensor: sensor)
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
