require 'rails_helper'

RSpec.describe HomeViewersController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }
  let(:my_friend) { FactoryGirl.create(:user) }
  let(:admin_role) { FactoryGirl.create(:role, name: 'janitor') }
  let(:admin_user) { FactoryGirl.create(:user, roles: [admin_role]) }
  let!(:home) { FactoryGirl.create(:home, owner_id: user.id) }
  let!(:another_home) { FactoryGirl.create(:home, name: "someone else's home") }
  let!(:public_home)  { FactoryGirl.create(:home, name: 'public home', is_public: true) }

  context 'not signed in ' do
    describe 'GET index' do
      before { get :index }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
    describe 'GET new' do
      before { get :new, home_id: home.to_param }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
    describe 'PUT create' do
      before { put :create, home_id: home.to_param }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
    describe 'DELETE' do
      before { delete :destroy, id: home.to_param, params: { user_id: my_friend } }
      it { expect(response).to redirect_to(new_user_session_path) }
    end
  end

  context 'user is signed in' do
    before { sign_in user }
    describe 'GET index' do
      before { get :index, home_id: home.to_param }
      it { expect(response).to have_http_status(:success) }
    end
    pending 'GET new'
    pending 'PUT create'
    pending 'DELETE'
    # describe 'POST add_authorized_viewer' do
    #   describe 'user already exists' do
    #     before do
    #       FactoryGirl.create(:user, email: 'bob@example.com')
    #       post :add_authorized_viewer, id: home.to_param, authorizedviewer: { email: 'bob@example.com' }
    #     end
    #     it { expect(response).to redirect_to(home) }
    #   end
    # end
  end

  context 'signed in as admin/janitor' do
    before { sign_in admin_user }
    pending 'GET index'
    pending 'GET new'
    pending 'PUT create'
    pending 'DELETE'
  end
end
