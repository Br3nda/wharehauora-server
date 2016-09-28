require 'rails_helper'

RSpec.describe WelcomeController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }
  context "user is not sign in" do
    describe "GET show" do
      before { get :index }
      it { expect(response).to have_http_status(:success) }
    end
  end
  context "user is signed in" do
    before do
      sign_in user
    end

    describe "GET show" do
      before { get :index }
      it { expect(response).to have_http_status(:success) }
    end
  end
end
