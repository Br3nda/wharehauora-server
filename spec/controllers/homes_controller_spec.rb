require 'rails_helper'

RSpec.describe HomesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { FactoryGirl.create(:user) }
  let(:home) { FactoryGirl.create(:home, owner_id: user.id) }

  context "user is signed in" do
    before do
      sign_in user
    end

    describe "GET show" do
      before { get :show, id: home.id }
      it { expect(response).to have_http_status(:success) }
    end

    describe "#update" do
      before { patch :update, id: home.to_param, home: { name: "New home name" } }
      it { expect(response).to redirect_to(home) }
    end

    describe "GET edit for someone else's home" do
      let(:another_home) { FactoryGirl.create(:home, name: "someone else's home") }
      before { get :edit, id: another_home.to_param }
      it { expect(response).to redirect_to(root_path) }
    end
  end
end
